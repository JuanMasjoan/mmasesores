import sqlite3
import os, io, csv
from Final.db import get_db
from datetime import datetime, date, timedelta
import datetime
from PyPDF2 import PdfReader




class Cons_gral:
    @staticmethod
    def con_db():
        db, c = get_db()
        return db, c

    
    @staticmethod
    def cons_gral(query, *arg):
        db, c = get_db()
        c.execute(query, arg)    
        tabla = c.fetchall()
        db.commit()
        return tabla
    
    @staticmethod
    def manejo_error(error_msj):
        if "Duplicate entry" in error_msj:
            return "El registro ya existe en la base de datos."
        elif "foreign key constraint fails" in error_msj:
            return "Existe una referencia a un registro relacionado que no existe."
        elif "Data too long" in error_msj:
            return "Los datos proporcionados exceden la longitud permitida."
        elif "Cannot delete or update a parent row" in error_msj:
            return "No se puede eliminar o actualizar este registro."
        elif "No data found for query" in error_msj:
            return "No se encontraron datos para la consulta realizada."
        elif "Access denied for user" in error_msj:
            return "Acceso denegado para el usuario. Verifique las credenciales de conexión."
        elif "Table doesn't exist" in error_msj:
            return "La tabla especificada no existe en la base de datos."
        elif "Unknown column" in error_msj:
            return "La columna especificada no existe en la tabla."
        elif "Incorrect syntax near" in error_msj:
            return "Error de sintaxis cerca de la consulta especificada."
        elif "Connection refused" in error_msj:
            return "La conexión a la base de datos fue rechazada. Verifique la configuración de conexión."
        else:
            return "Ocurrió un error durante el proceso. Por favor, inténtelo nuevamente más tarde."

class ManejoFechas:
    def __init__(self,):    
        self.fecha_actual = datetime.datetime.now()
    
    
    def fecha_2actual(self,):    

        date_actual_final = self.fecha_actual.strftime('%Y-%m-%d')

        return date_actual_final 


    def fecha_hoy_DDMM(self):
        fecha_hoy_DDMM = self.fecha_actual.strftime('%d-%m')
        return fecha_hoy_DDMM
    
    def fechas_15_dias (self,):  

        date_15_dias = self.fecha_actual + datetime.timedelta(days=15)
        date_15_dias_final = date_15_dias.strftime('%Y-%m-%d')

        return date_15_dias_final 

    def fechas_30_dias (self,):
        
        date_30_dias = self.fecha_actual + datetime.timedelta(days=30)
        date_30_dias_final = date_30_dias.strftime('%Y-%m-%d')

        return date_30_dias_final
   
    def fechas_15_antes (self,):  

        date_15_dias = self.fecha_actual + datetime.timedelta(days=-15)
        date_15_dias_final = date_15_dias.strftime('%Y-%m-%d')
        
        return date_15_dias_final 
    
    def fechas_180_antes (self,):  

        date_180_dias = self.fecha_actual + datetime.timedelta(days=-180)
        date_180_dias_final = date_180_dias.strftime('%Y-%m-%d')
        
        return date_180_dias_final  
    
    def fechas_365_dsp (self,fecha_mod):  
        
        fecha_mod = datetime.datetime.strptime(fecha_mod, '%Y-%m-%d')
        data_365_dsp =  fecha_mod + timedelta(days=365) 
        data_365_dsp_final  = data_365_dsp.strftime('%Y-%m-%d')
        
        return data_365_dsp_final 
    
    def fechas_180_dsp (self,):  

        date_180_dsp = self.fecha_actual + datetime.timedelta(days=+180)
        date_180_dsp_final = date_180_dsp.strftime('%Y-%m-%d')
        
        return date_180_dsp_final
      
class ManejarFormulariosPost:
    def __init__(self, request_form, campos):
        self.valores = {}
        self.request_form = request_form
        self.campos = campos
    
    def __getitem__(self, key):
        return self.valores[key]
 
    def obtener_valor(self, campo):
        return self.request_form.get(campo, '')
    
    def obtener_valores(self,):
        for campo in self.campos:
            self.valores[campo] = self.obtener_valor(campo)
            
            
    def convertir_nulos(self):
        for campo, valor in self.valores.items():
            if valor == 'None':
                self.valores[campo] = None
        
    def convertir_vacios(self):
        for campo, valor in self.valores.items():
            if not valor :
                self.valores[campo] = None 
    
    
class Insert_tabla:
    def __init__(self):
        db, c = get_db()
        self.db = db
        self.c = c

    def insert_sp(self, sp_name, *args):
        try:
            self.c.callproc(sp_name, *args)
            self.db.commit()
            datos = []
            for result in self.c.stored_results():             
                datos.extend(result.fetchall()) 
            
            return True, datos
        except Exception as e:
            error = f"{e}"
            error_msj = Cons_gral.manejo_error(error)
            self.db.rollback()
            return False, error_msj

    def select_sp(self, sp_name, *args):    
        try:
            self.c.callproc(sp_name, *args)
            datos = []
            for result in self.c.stored_results():
                datos.extend(result.fetchall())
            
            return True, datos 
        
        except Exception as e:
            error = f"{e}"
            error_msj = Cons_gral.manejo_error(error)
            print("Error en stored procedure:", error)  

            self.db.rollback()
            return False, error_msj

    def separadores_info_cliente(self,):
        
        success_info_alta, data = self.select_sp('sp_info_inser_poliza')

        indice_separador = [i for i, d in enumerate(data) if d.get('separador') == 'SEPARADOR']
        
        if len(indice_separador) >= 6:
            partes = [data[indice_separador[i] + 1:indice_separador[i + 1]] for i in range(5)]

            partes.append(data[indice_separador[5] + 1:])

            info_productor, info_ramo, info_cia, info_form_pago_cl, info_ciclo_fact, info_estado_poliza = partes

            return success_info_alta,info_productor, info_ramo, info_cia, info_form_pago_cl, info_ciclo_fact, info_estado_poliza 
        else:
            print("No se encontraron suficientes separadores en los datos para dividir en  partes.")
            return success_info_alta,None, None , None, None , None, None

    def select_sp_4_resultados(self,sp_name,*args):
        if args == None:
            try:
                self.c.callproc(sp_name)

                resultado1 = []
                resultado2 = []
                resultado3 = []
                resultado4 = []
                
                for result in self.c.stored_results():
                    if not resultado1:
                        resultado1.extend(result.fetchall())
                    elif not resultado2:
                        resultado2.extend(result.fetchall())
                    elif not resultado2:
                        resultado3.extend(result.fetchall())
                    else:
                        resultado4.extend(result.fetchall())
                
                return (True, resultado1, resultado2, resultado3,resultado4)

            except Exception as e:
                error = f"{e}"
                error_msj = Cons_gral.manejo_error(error)
                print("primer Error en SELECT 1 o SELECT 2:", error)
                self.db.rollback()
                return (False, error_msj, None, None, None)
            
        else:  
            try:
                self.c.callproc(sp_name,*args)

                resultado1 = []
                resultado2 = []
                resultado3 = []
                resultado4 = []
                
                
                for result in self.c.stored_results():
                    if not resultado1:
                        resultado1.extend(result.fetchall())
                    elif not resultado2:
                        resultado2.extend(result.fetchall()) 
                    elif not resultado3:
                        resultado3.extend(result.fetchall()) 
                    else:
                        resultado4.extend(result.fetchall())

                return (True, resultado1, resultado2, resultado3, resultado4)

            except Exception as e:
                error = f"{e}"
                error_msj = Cons_gral.manejo_error(error)
                print("segundoo Error en SELECT 1 o SELECT 2:", error)
                self.db.rollback()
                return (False, error_msj, None , None, None)                
    
    def select_sp_5_resultados(self, sp_name, *args):
        if args is None:
            try:
                self.c.callproc(sp_name)

                resultado1 = []
                resultado2 = []
                resultado3 = []
                resultado4 = []
                resultado5 = []  
                
                for result in self.c.stored_results():
                    if not resultado1:
                        resultado1.extend(result.fetchall())
                    elif not resultado2:
                        resultado2.extend(result.fetchall())
                    elif not resultado3:
                        resultado3.extend(result.fetchall())
                    elif not resultado4: 
                        resultado4.extend(result.fetchall())
                    else:
                        resultado5.extend(result.fetchall())  
                    
                return (True, resultado1, resultado2, resultado3, resultado4, resultado5)

            except Exception as e:
                error = f"{e}"
                error_msj = Cons_gral.manejo_error(error)
                print("primer Error en SELECT 1 o SELECT 2:", error)
                self.db.rollback()
                return (False, error_msj, None, None, None, None)
        
        else:  
            try:
                self.c.callproc(sp_name, *args)

                resultado1 = []
                resultado2 = []
                resultado3 = []
                resultado4 = []
                resultado5 = []  
                
                for result in self.c.stored_results():
                    if not resultado1:
                        resultado1.extend(result.fetchall())
                    elif not resultado2:
                        resultado2.extend(result.fetchall()) 
                    elif not resultado3:
                        resultado3.extend(result.fetchall()) 
                    elif not resultado4:  
                        resultado4.extend(result.fetchall())
                    else:
                        resultado5.extend(result.fetchall())  

                return (True, resultado1, resultado2, resultado3, resultado4, resultado5)

            except Exception as e:
                error = f"{e}"
                error_msj = Cons_gral.manejo_error(error)
                print("segundo Error en SELECT 1 o SELECT 2:", error)
                self.db.rollback()
                return (False, error_msj, None, None, None, None)

    def select_sp_2_resultados(self,sp_name,*args):
    
        if args == None:
            try:
                self.c.callproc(sp_name)

                resultado1 = []
                resultado2 = []
                
                for result in self.c.stored_results():
                    if not resultado1:
                        resultado1.extend(result.fetchall())
                    elif not resultado2:
                        resultado2.extend(result.fetchall())

                return (True, resultado1, resultado2)

            except Exception as e:
                error = f"{e}"
                error_msj = Cons_gral.manejo_error(error)
                print("primer Error en SELECT 1 o SELECT 2:", error)
                self.db.rollback()
                return (False, error_msj, None)
            
        else:  
            try:
                self.c.callproc(sp_name,*args)

                resultado1 = []
                resultado2 = []
                
                for result in self.c.stored_results():
                    if not resultado1:
                        resultado1.extend(result.fetchall())
                    elif not resultado2:
                        resultado2.extend(result.fetchall()) 

                return (True, resultado1, resultado2)

            except Exception as e:
                error = f"{e}"
                error_msj = Cons_gral.manejo_error(error)
                print("segundoo Error en SELECT 1 o SELECT 2:", error)
                self.db.rollback()
                return (False, error_msj, None )                
        
    
class Eliminar_Registros:
    def __init__(self):
        db, c = get_db()
        self.db = db
        self.c = c
    
    def eliminar_registros(self, sp_name, id_eliminar):
        try:
            self.c.callproc(sp_name, [id_eliminar])
            self.db.commit()
            return True
        except Exception as e:
            print(f"Error al ejecutar funcion: {e}")
            self.db.rollback()
            return False

class Select_Registros:
    def __init__(self):
        db, c = get_db()
        self.db = db
        self.c = c
    
    def buscar_cia(self, p_cuit_cia):
        try:
            self.c.execute("SELECT cartera_cliente.busc_cia(%s);", (p_cuit_cia,))
            id_cia = self.c.fetchone()[0]
            
            return id_cia
        
        except Exception as e:
            return str(e)    

class LectorArchivos:
    def __init__(self, pdf_content):
        self.pdf_reader = PdfReader(pdf_content)
    
    def obtener_contenido_completo(self):
        contenido_completo = ""
        for page in self.pdf_reader.pages:
            contenido_pagina = page.extract_text()
            contenido_completo += contenido_pagina
        return contenido_completo
    
    @property
    def numero_factura(self):
        return self.extraer_dato('Comp. Nro:')
    
    @property
    def fecha_factura(self):
        return self.extraer_dato('Domicilio:')
    
    @property
    def fecha_correcta(self):
        fecha = self.fecha_factura
        partes = fecha.split()
        ult_parte = partes[-1]
        fecha_correcta = ult_parte[-10:] 
  
        return fecha_correcta
    
    @property
    def valor_comisiones(self):
        _comisiones = self.extraer_dato('unidades ')      
        partes_comisiones = _comisiones.split()
        monto_comisiones_ = partes_comisiones[1]
        _monto_comisiones_ = monto_comisiones_.replace(',','.')
        monto_comisiones = round(float(_monto_comisiones_), 2)
        return monto_comisiones
         
    @property
    def titular(self):
        return self.extraer_dato('Comercial:Razón Social:')    
    
    def mes_factura(self, partes):
        for fecha in partes:
            partes_fecha = fecha.split('/')
            if len(partes_fecha) == 3:
                mes_factura = partes_fecha[1]
                return mes_factura  
    
    def ano_factura(self, partes):
        for fecha in partes:
            partes_fecha = fecha.split('/')
            if len(partes_fecha) == 3:
                ano_factura = partes_fecha[2]
                return ano_factura                 

    def id_cia(self):      
         
        contenido_completo = self.obtener_contenido_completo()
        lineas = contenido_completo.split('\n')
        
        indice_codigo_producto = None
        for i, linea in enumerate(lineas):
            if 'Código Producto' in linea:
                indice_codigo_producto = i
                break

        if indice_codigo_producto is not None and indice_codigo_producto > 0:
            linea_anterior = lineas[indice_codigo_producto - 1]
            return linea_anterior
        else:
            return "No se encontró 'Código Producto' en el archivo."
        
    def comision_final(self):
        __comisiones = self.valor_comisiones        
        try:
            descuento = __comisiones * 0.08            
            comision_final = round(__comisiones - descuento, 2)
            
        except ValueError:
                comision_final = 'ERROR' 

        
        return comision_final
               
    def retenciones_final(self):
        _retenciones_final = self.valor_comisiones        
        try:
            retenciones_final = _retenciones_final * 0.08            
            
        except ValueError:
                retenciones_final = 'ERROR' 

        
        return retenciones_final
    

    def extraer_dato(self, etiqueta):
            for page in self.pdf_reader.pages:
                texto_pagina = page.extract_text()
                if etiqueta in texto_pagina:
                    inicio = texto_pagina.index(etiqueta) + len(etiqueta)
                    fin = texto_pagina.find('\n', inicio)
                    if fin == -1:
                        fin = None
                    return texto_pagina[inicio:fin].strip()
            return None       
   
    def obtener_componentes_fecha(self):
        fecha = self.fecha_factura
        partes = fecha.split()
        ult_parte = partes[-1]
        componentes_fecha = ult_parte[-10:].split('/')
        return componentes_fecha

    def fecha_correcta_insert(self):
        componentes_fecha = self.obtener_componentes_fecha()
        
        if len(componentes_fecha) == 3:
            dia, mes, año = componentes_fecha
            nueva_fecha = f"{año}/{mes}/{dia}"
            return nueva_fecha
        else:
            print("Formato de fecha no válido")
            return None      
        
        
class TareasComunes:
    def __init__(self, dato):
        self.dato = dato

    def crear_lista_tuplas(self):
        dato_tupla = [(fila['id_estado_poliza'], fila['estado_poliza']) for fila in self.dato]
        return dato_tupla

    @staticmethod
    def calcular_promedio(numeros):
        if len(numeros) == 0:
            return 0
        suma = sum(numeros)
        promedio = suma / len(numeros)
        return promedio
           
## PROBAR SI FUNCIONAAAAAAA
class Lector_Csv:
    def __init__ (self,arvhivo):
        self.archivo = arvhivo
    
    def lector_csv (self):    
    
        csv_filename = 'temp.csv'
        self.archivo.save(csv_filename)

        # Procesa el archivo CSV
        with open(csv_filename, newline='', encoding='utf-8') as archivo_csv:
            lector = csv.reader(archivo_csv, delimiter='\t')
            data = [fila for fila in lector]

        # Elimina el archivo CSV temporal
        import os
        os.remove(csv_filename)

        return data
      

def execute_view(connection, view_name, filtro, id_column, dato_buscar1, dato_buscar2=None):

    def colum_x_dato(self, sp_name, column0, column1, *args):
        try:
            self.c.callproc(sp_name, *args)
            datos = self.c.fetchall()
            values = [(fila[column0[0]], fila[column1[1]]) for fila in datos]
            return values
        except Exception as e:
            error = f"{e}"
            error_msj = Cons_gral.manejo_error(error)
            self.db.rollback()
            return False, error_msj
    
def insert_sp_(self, sp_name, *args):
    try:
        # Define una variable de salida para almacenar el resultado
        result = self.c.var(int)
        self.c.execute("SET @p_result = NULL")
        resultado = None
        # Llama al procedimiento almacenado con la variable de salida
        self.c.callproc(sp_name, [args, resultado])

        result = self.c.fetchone()[1]
        
        self.db.commit()
        
        
        return True, resultado  # Devuelve el valor obtenido desde la variable de salida
    except Exception as e:
        error = f"{e}"
        error_msj = Cons_gral.manejo_error(error)
        self.db.rollback()
        return False, error_msj
        

        
class Cons_Tabla_Total:
    def __init__(self, tabla):
        self.tabla = tabla
        self.query_original =  f"SELECT * FROM cartera_cliente.{self.tabla}"
    
    ## estaria incluida en las anteriores -- queda para pruebas

    
    def select_sp(self, sp_name, *args):
        try:
            self.c.callproc(sp_name, *args)
            datos = self.c.fetchall()
            return datos 
        except Exception as e:
            error = f"{e}"
            error_msj = Cons_gral.manejo_error(error)
            self.db.rollback()
            return False, error_msj
        
    def mostrar_tabla(self, condicion=None):
        #fx para tabla especifica
        query = self.query_original
        if condicion :
            query += f" WHERE {condicion}"
        data = Cons_gral.cons_gral(query)
        return data
    
    def mostrar_tabla_igual(self,con_tipo = None, con_texto=None):
        #fx para mostrar igualdad entre col=x
        query = self.query_original
        if con_tipo :
            query += f" WHERE {con_tipo} = {con_texto}"
        data = Cons_gral.cons_gral(query)
        return data
    
    def mostrar_tabla_like(self, con_tipo=None, con_texto=None):
        #funcion Like de mostrar_tabla_igual
        query = self.query_original
        if con_texto and con_tipo:
            query += f" WHERE {con_tipo} LIKE '%{con_texto}%'"
                   
        data = Cons_gral.cons_gral(query)
        return data

    def fx_cambio_estado(self, nombre_funcion, *args):
        #fx para fx especifica en db
        try:
            query = f"SELECT {nombre_funcion}({', '.join(['%s' for _ in args])})"
            result = Cons_gral.cons_gral(query, *args)
            return result
        except Exception as e:
            print(f"Error al ejecutar funcion: {e}")
            return None
        

class Mod_tabla_fx:
    def __init__(self, fx):
        self.fx = fx
        self.query_original =  f"SELECT * FROM cartera_cliente.fx_{self.fx}"

    def ejecutar_fx_tg_ag_visitas(self, valor_id_ag_cartera, valor_id_prod_acaptar, valor_prod_logrados, valor_comentarios, valor_estado_contacto):
        db , c =get_db()
        query = f"SELECT cartera_cliente.fx_tg_ag_visitas('{valor_id_ag_cartera}', '{valor_id_prod_acaptar}', '{valor_prod_logrados}', '{valor_comentarios}','{valor_estado_contacto}')"
        param  = (valor_id_ag_cartera, valor_id_prod_acaptar, valor_prod_logrados, valor_comentarios,valor_estado_contacto)
        relizado = Cons_gral.cons_gral(query)
        db.commit()

       # return relizado

