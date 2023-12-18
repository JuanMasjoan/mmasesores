import sqlite3
import os

class DatabaseManager:
    def __init__(self, db_name):
        self.db_name = db_name
        self.conn = None
        self.c = None

    def connect(self):
        self.conn = sqlite3.connect(self.db_name)
        self.c = self.conn.cursor()

    def close(self):
        if self.c:
            self.c.close()
        if self.conn:
            self.conn.close()

    def execute_query(self, query, params=None):
        if not self.c:
            self.connect()

        if params is None:
            self.c.execute(query)
        else:
            self.c.execute(query, params)

    def commit(self):
        if self.conn:
            self.conn.commit()

    def fetch_all(self):
        if self.c:
            return self.c.fetchall()
        return None

    def crear_tablas(self):
        self.connect()

        self.c.execute('''
            CREATE TABLE tareas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            id_tipo_tareas TEXT NOT NULL,
            descripcion TEXT,
            duracion INTEGER,
            fecha DATE,
            realizado INTEGER DEFAULT 0
            )
        ''')

        self.c.execute('''
            CREATE TABLE tipos_tareas (
                id_tipos_tareas INTEGER PRIMARY KEY AUTOINCREMENT,
                tipos_tareas TEXT NOT NULL
            )
        ''')

        tipos_tareas = [
            ('PROGRAMAR',),
            ('TIEMPO A MI CASA',),
            ('PAS',),
            ('SALIR AFUERA',),
            ('OFICINA',),
            ('REUNION',),
            ('EJERCICO',),
            ('LIBRE',)
        ]
        self.c.executemany('INSERT INTO tipos_tareas (tipos_tareas) VALUES (?)', tipos_tareas)
            
        self.c.execute('''
                  ALTER TABLE tareas ADD COLUMN nombre_tipo_tarea TEXT
            ''')
        
        self.c.execute('''
                        UPDATE tareas
                        SET tipo_tarea_id = (SELECT id_tipos_tareas FROM tipos_tareas 
                        WHERE tipos_tareas.tipos_tareas = tareas.nombre_tipo_tarea)
    	        ''')    
        
        self.conn.commit()
        self.close()

    def crear_views (self):
        self.connect()
        
        self.c.execute(
            '''CREATE VIEW vista_tareas AS
                SELECT tipos_tareas.tipos_tareas, tareas.descripcion, tareas.duracion, tareas.fecha, tareas.realizado
                FROM tareas
                JOIN tipos_tareas ON tareas.tipo_tarea_id = tipos_tareas.tipo_tarea_id;
            '''
        )
        
        self.conn.commit()
        self.close()
        
   
        
class TaskManager:
    def __init__(self, db_name='tareas_diarias.db'):
        self.db_name = db_name
        self.db_manager = DatabaseManager(db_name)

    def crear_tablas(self):
        self.db_manager.crear_tablas()

    ## unificar las dos consultas, esta y la siguiente.
    
    def todas_las_tareas(self):
        self.db_manager.connect()
        self.db_manager.execute_query('SELECT * FROM tareas ')
        tareas = self.db_manager.fetch_all()
        self.db_manager.close()
        return tareas

    def tareas_por_fecha(self, fecha):
        self.db_manager.connect()
        self.db_manager.execute_query('SELECT * FROM vista_tareas WHERE fecha = ?', (fecha,))
        tareas = self.db_manager.fetch_all()
        self.db_manager.close()
        return tareas

    def tipo_tareas(self):
        self.db_manager.connect()
        self.db_manager.execute_query('SELECT * FROM tipos_tareas ')
        tipo_tareas = self.db_manager.fetch_all()
        self.db_manager.close()
        return tipo_tareas
    
    def vw_tareas(self):
        self.db_manager.connect()
        query = 'SELECT * from vista_tareas'
        try:
            self.db_manager.execute_query('SELECT * from vista_tareas')
            vw_tareas = self.db_manager.fetch_all()
            ## self.db_manager.close()
            return vw_tareas , True
        except:
            self.db_manager.crear_views()
            self.db_manager.execute_query(query)
            vw_tareas = self.db_manager.fetch_all()
            self.db_manager.close()
            return vw_tareas , False
            
    
    def agregar_tarea(self, titulo, descripcion, duracion, fecha,tipo_tarea_id):
        self.db_manager.connect()
        self.db_manager.execute_query(
            'INSERT INTO tareas (titulo, descripcion, duracion, fecha, tipo_tarea_id) VALUES (?, ?, ?, ?,?)',
            (titulo, descripcion, duracion, fecha, tipo_tarea_id)
        )
        self.db_manager.commit()
        self.db_manager.close()

    def mark_task_completed(self, tarea_id):
        self.db_manager.connect()
        self.db_manager.execute_query('UPDATE tareas SET realizado = 1 WHERE id = ?', (tarea_id,))
        self.db_manager.commit()
        self.db_manager.close()

    def delete_task(self, tarea_id):
        self.db_manager.connect()
        self.db_manager.execute_query('DELETE FROM tareas WHERE id = ?', (tarea_id,))
        self.db_manager.commit()
        self.db_manager.close()
        
