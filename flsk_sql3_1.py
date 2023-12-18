import os

from flask import Flask, Blueprint, render_template, request, redirect, url_for

from Final.auth import login_required
import sqlite3
from Final.db_sqlt3 import TaskManager
from datetime import datetime, timedelta  



    
bp = Blueprint('flsk_sql3_1', __name__)
task_manager = TaskManager()

@bp.route('/tareas_diarias', methods=['GET', 'POST'])
@login_required
def tareas_diarias():
    tareas = []
    fecha_anterior=[]
    fecha_actual = datetime.now().date()
    fecha_anterior = []
    ##task_manager.crear_tablas()            


    
    tipo_tareas = task_manager.tipo_tareas()
    vw_tareas, condiccion= task_manager.vw_tareas()
    todas_tareas= task_manager.todas_las_tareas()
    
    print(condiccion, vw_tareas, '-------- EMPIEZA LA OTRA ---------',todas_tareas)
    # try:
    #     tareas = task_manager.todas_las_tareas()
    #     tipo_tareas = task_manager.tipo_tareas()
    #     tareas = task_manager.tareas_por_fecha()
    #     tareas_todas = task_manager.vw_tareas()
        
        
    #     print (tareas, 'sadd')
    # except:
    #     task_manager.crear_tablas()            
    
    if request.method == 'POST':
        
        if 'agregar_tarea' in request.form:   
            titulo = request.form['titulo']
            descripcion = request.form['descripcion']
            duracion = request.form['duracion']
            fecha = request.form['fecha_actual']
            
            resultado = task_manager.agregar_tarea(titulo, descripcion,  duracion, fecha, titulo)
            
            
            
            print (resultado) 
            
            return redirect(url_for('flsk_sql3_1.tareas_diarias'))

        if 'ss' in request.form:
            fecha_anterior = fecha_actual - timedelta(days=1)
            fecha_seleccionada_str = request.form['fecha_seleccionada']
            fecha_seleccionada = datetime.strptime(fecha_seleccionada_str, '%Y-%m-%d').date()
            tareas = task_manager.tareas_por_fecha(fecha_seleccionada)

            ##pipo =  fecha_actual
            ##fecha1 = pipo - timedelta(days=1)
            fecha = '2023-07-26'

            fecha1 = fecha_actual - timedelta(days=1)

            #fecha_distinta = '2023-07-26'
            #tareas_prueba = task_manager.tareas_por_fecha(fecha_distinta)
        
           
            return render_template('todo/tareas_diarias.html', tareas=tareas, tipo_tareas=tipo_tareas,
                            fecha_actual=fecha_actual, fecha_anterior=fecha_anterior)
            
            #return render_template('/hola')
        
        
        
    return render_template('todo/tareas_diarias.html', tareas=vw_tareas , tipo_tareas = tipo_tareas,
                               fecha_actual=fecha_actual, fecha_anterior = fecha_anterior)
                            
    

@bp.route('/tareas_diarias/completar/<int:tarea_id>', methods=['POST'])
def completar_tarea(tarea_id):
    task_manager.mark_task_completed(tarea_id)
    return redirect(url_for('flsk_sql3_1.tareas_diarias'))

@bp.route('/tareas_diarias/eliminar/<int:tarea_id>', methods=['POST'])
def eliminar_tarea(tarea_id):
    task_manager.delete_task(tarea_id)
    return redirect(url_for('flsk_sql3_1.tareas_diarias'))

