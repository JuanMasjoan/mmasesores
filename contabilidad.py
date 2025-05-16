import os,io ,re ,tempfile 
from os import error
from Final.auth import login_required

from flask import (
    Blueprint, redirect, url_for, flash, g, render_template, request, send_file
)
from Final.def_mod_contabilidad import (Consultas_contabilida)
from Final.class_metodo import (
    Eliminar_Registros, Cons_Tabla_Total ,Mod_tabla_fx,Insert_tabla, ManejoFechas , ManejarFormulariosPost,
    Cons_gral, LectorArchivos, Select_Registros,Lector_Csv )
from datetime import date,timedelta, datetime


bp = Blueprint('contabilidad', __name__)



@bp.route('/contabilidad')
@login_required
def contabilidad():
    return render_template('todo/contabilidad.html')


@bp.route('/carga_factura', methods = ['GET','POST'])
@login_required
def carga_factura():
    cons_cia = Cons_Tabla_Total('cia')
    tabla_cia = cons_cia.mostrar_tabla()
    valores_cia = [(fila['id_cia'], fila['cia']) for fila in tabla_cia]

    if request.method == 'POST':
        file = request.files['factura_pdf']
        tipo_factura = request.form['tipo_factura'] 
        id_cia   = request.form['id_cia'] 
        id_cobrada = '1 ' if 'ajustado_dolar' in request.form else '0'
        
        if file and file.filename.endswith('.pdf'):

            temp_pdf = tempfile.NamedTemporaryFile(delete=False)
            temp_pdf.write(file.read())
            temp_pdf.close()

            lector = LectorArchivos(temp_pdf.name)
            pto_venta_comp = lector.numero_factura
            pto_vnta, comprobante = pto_venta_comp.split()
            
            fecha_factura_ = lector.fecha_factura
            partes = fecha_factura_.split()
            ult_parte = partes[-1]
            _fecha_factura_ = ult_parte[-10:]                   
            
            
            try:
                fecha_obj = datetime.strptime(_fecha_factura_, "%d/%m/%Y")
                fecha_factura = fecha_obj.strftime("%Y/%m/%d")
                print(fecha_factura)
                # Esto imprimirá la fecha en el nuevo formato AAAA/MM/DD
            except ValueError:
                print("Formato de fecha no válido")
                
            fecha_factura_insert = lector.fecha_correcta_insert()
         
            mes_factura = lector.mes_factura(partes)
            ano_factura = lector.ano_factura(partes)
               
            monto_comisiones = lector.valor_comisiones
            monto_retenciones = lector.retenciones_final()
            
            titular = lector.titular
            
            
            # id_cia = lector.id_cia()
            # partes_cia = id_cia.split()
            # cia = partes_cia[1]
            #selector = Select_Registros()
            # id_cia = selector.buscar_cia(cia)
            
            # print (cia)
            # print (id_cia)
                       
            ##contenido_completo = lector.obtener_contenido_completo()
            insert_values = (comprobante,fecha_factura,tipo_factura,id_cia,mes_factura,monto_comisiones,
                             monto_retenciones,id_cobrada, ano_factura, pto_vnta, titular)
            
            insertador = Insert_tabla()
            
            success, ins_facturas = insertador.insert_sp('sp_ins_factura', insert_values)
            
            if success :
                alerta = 'Realizado'
                flash(alerta)
            else:
                alerta = 'Error '
                flash(ins_facturas)

    
    return render_template('todo/contabilidad/carga_factura.html' , valores_cia = valores_cia)


@bp.route('/facturas_cia', methods = ['GET','POST'])
@login_required
def facturas_cia():
    selector = Insert_tabla()
    values_insert = None
    success, select_data_1, select_data_2 , select_data_3, select_data_4 = selector.select_sp_4_resultados('sp_fact_cia',)
    
    if request.method == 'POST':
        itinerador_contabilidad = Consultas_contabilida()
        itinerador_contabilidad.actualizar_cobro()
        
        

    return render_template('todo/contabilidad/facturas_cia.html', fact = select_data_1, 
                            rest_ult_ano = select_data_2, rest_ult_mes = select_data_3,
                            fact_pend = select_data_4)


@bp.route('/vista_de_cartera_x_ramo', methods = ['GET','POST'])
@login_required
def vista_de_cartera_x_ramo():
    selector = Insert_tabla()
    itinerador_contabilidad = Consultas_contabilida()
    succes1,tabla_x_ramo,tabla_x_cia ,info_cia,info_rama, total_polizas= selector.select_sp_5_resultados('sp_consulta_info_cantidad_polizas_ramo')

   
    if succes1 == True:
        
        if request.method == 'POST':
            count_elementos, elementos= itinerador_contabilidad.consulta_vista_cartera_x_ramo()
            
            return render_template('todo/contabilidad/vista_de_cartera_x_ramo.html', info_cia=info_cia,
                                    info_rama = info_rama, tabla_x_ramo= tabla_x_ramo, 
                                    tabla_x_cia = tabla_x_cia, count_elementos = count_elementos,
                                    elementos = elementos, total_polizas = total_polizas)
            
        return render_template('todo/contabilidad/vista_de_cartera_x_ramo.html', info_cia=info_cia,
                                info_rama = info_rama, tabla_x_ramo= tabla_x_ramo, 
                                tabla_x_cia = tabla_x_cia, total_polizas = total_polizas)
    
    else:
        flash('Error para cargar la pagina')
        return render_template('todo/contabilidad/vista_de_cartera_x_ramo.html')
