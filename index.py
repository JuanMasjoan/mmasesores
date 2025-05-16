import os,io ,re ,tempfile ,PyPDF2 ,datetime
from os import error

from flask import (
    Blueprint, redirect, url_for, flash, g, render_template, request, send_file
)

from werkzeug.exceptions import abort
from Final.auth import login_required
from Final.db import get_db
from Final.class_metodo import (
    Eliminar_Registros, Cons_Tabla_Total ,Mod_tabla_fx,Insert_tabla, ManejoFechas , ManejarFormulariosPost,
    Cons_gral, LectorArchivos, Select_Registros,Lector_Csv )
from datetime import date,timedelta, datetime
from PyPDF2 import PdfReader

bp = Blueprint('todo', __name__)
fechas = ManejoFechas()

@bp.route('/')
@login_required
def index():
   
    return render_template('todo/index.html')


@bp.route('/mantenimiento_cartera')
@login_required
def mantenimiento_cartera():
    return render_template('todo/mantenimiento_cartera.html')


@bp.route('/expansion_clientes')
@login_required
def expansion_clientes():
    return render_template('todo/expansion_clientes.html')


@bp.route('/agenda')
@login_required
def agenda():
   return render_template('todo/agenda.html')

@bp.route('/estadisticas')
@login_required
def estadisticas():
    return render_template('todo/estadisticas.html')


# para ag_cartera: adaptar los estados del tg estado contacto para
# que sean predefinidos. usar mismo formato que estado_civil


@bp.route('/ag_cartera', methods = ['GET', 'POST'])
@login_required
def ag_cartera():

    cons_ag_cartera = Cons_Tabla_Total('tg_ag_visitas')
    tabla_ag_cartera = cons_ag_cartera.mostrar_tabla()
    valor_id_ag_cartera = []

    if request.method == 'POST':

        if 'agregar_nuevo' in request.form:

            return redirect(url_for('todo.nv_ag_cartera'))

        elif 'Elimninar_contacto_cliente' in request.form:
            valor_id_ag_cartera = request.form.get('Elimninar_contacto_cliente')

            insertador = Eliminar_Registros()
            insertador.eliminar_registros('SP_DEL_AG_VISITAS', valor_id_ag_cartera)

            return redirect(url_for('todo.ag_cartera'))

        elif 'id_contacto_cliente' in request.form:
            valor_id_ag_cartera = request.form.get('id_contacto_cliente')
            valor_id_prod_acaptar = request.form.get('prod_acaptar')
            valor_prod_logrados = request.form.get('prod_logrados')
            valor_comentarios = request.form.get('comentarios')
            valor_estado_contacto = request.form.get('estado_contacto')

            procesar_fx_ag = cons_ag_cartera.fx_cambio_estado('fx_tg_ag_visitas',valor_id_ag_cartera, valor_id_prod_acaptar,valor_prod_logrados,valor_comentarios ,valor_estado_contacto)

            return redirect(url_for('todo.ag_cartera'))

    return render_template('/todo/ag_cartera.html',tabla_ag_cartera = tabla_ag_cartera)

@bp.route('/nv_ag_cartera', methods = [ 'GET','POST'])
@login_required
def nv_ag_cartera():
    cons_productor = Cons_Tabla_Total ('productor')
    tabla_productor = cons_productor.mostrar_tabla()
    valores_productor =[(fila['id_productor'], fila['productor']) for fila in tabla_productor]

    if request.method == 'POST':
        valor_tg_id_productor = request.form.get('id_productor')
        valor_tg_id_dni = request.form.get('tg_id_dni')
        valor_tg_nombre_apellido = request.form.get('tg_nombre_apellido')
        valor_tg_prod_acaptar = request.form.get('tg_prod_acaptar')
        valor_tg_prod_logrados = request.form.get('tg_prod_logrados')
        valor_tg_comentarios = request.form.get('tg_comentarios')
        valor_tg_estado_contacto = request.form.get('tg_estado_contacto')
        valor_tg_COMPLETED = request.form.get('tg_COMPLETED')
        if valor_tg_COMPLETED == 'on':
            valor_tg_COMPLETED = 1
        else:
            valor_tg_COMPLETED = 0

        tg_fecha_contacto =  datetime.now()

        values_insert = (valor_tg_id_productor, valor_tg_id_dni,valor_tg_nombre_apellido,tg_fecha_contacto,
                       valor_tg_prod_acaptar,valor_tg_prod_logrados,
                       valor_tg_comentarios,valor_tg_estado_contacto,
                        valor_tg_COMPLETED)



        insertador = Insert_tabla()
        success , error_msj= insertador.insert_sp('SP_NV_AG_CARTERA', values_insert)


        if success :
            alerta = 'Realizado'
            flash(alerta)
        else:
            alerta = 'Error '
            flash(error_msj)

        return redirect(url_for('todo.ag_cartera'))

    return  render_template('/todo/nv_ag_cartera.html', valores_productor = valores_productor)


@bp.route('/buscador_poliza', methods = ['GET','POST'])
@login_required
def buscador_poliza():
    mostrar_tabla = []

    if request.method == 'POST':
        cons_cliente_poliza = Cons_Tabla_Total('vw_pol_act')
        mostrar_tabla = cons_cliente_poliza.mostrar_tabla()
        cons_cl_pol_total = Cons_Tabla_Total('vw_polizas')
        ch_most_todas = request.form.get('ch_most_todas')

        if  ch_most_todas == 'on':
            tipo = request.form['buscador_tipo']
            texto = request.form['buscador_texto']

            mostrar_tabla = cons_cl_pol_total.mostrar_tabla_like(tipo,texto)
        else:
            tipo = request.form['buscador_tipo']
            texto = request.form['buscador_texto']
            mostrar_tabla = cons_cliente_poliza.mostrar_tabla_like(tipo,texto)

    return render_template('todo/buscador_poliza.html', tabla_cons_poliza_amostrar = mostrar_tabla)


# ## como veerificar textos en otras partes del codigo
# if not isinstance(tipo, str) or not isinstance(texto, str):
#     flash ('Datos no habilitados ')

@bp.route('/cargar_mora', methods=['GET', 'POST'])
@login_required
def lector_mora():
    
    if request.method == 'POST':
        uploaded_file = request.files['carga_mora']
        
        if uploaded_file.filename != '':
            lector = Lector_Csv(uploaded_file)
            lala = lector.lector_csv()
            
            print(lala)
            
    return render_template('todo/cargar_mora.html')

