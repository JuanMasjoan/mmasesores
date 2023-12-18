from flask import (
    Blueprint, redirect, url_for, flash, render_template, request
)
from Final.db import get_db
from Final.auth import login_required
from datetime import date,timedelta, datetime
from Final.class_metodo import Insert_tabla , TareasComunes, ManejarFormulariosPost
from Final.def_mod_pan_cl import DefMoDPanCl, Info_Panel_cl

bp = Blueprint('pan_cl', __name__)

@bp.route('/pan_cl_1/<int:cliente_id>', methods=['GET','POST'] )
@login_required
def pan_cl_1(cliente_id):
    itinerador= DefMoDPanCl(cliente_id)
    itinerador_info = Info_Panel_cl()
    id_cliente = (cliente_id,)

    succes_tabla_panel_cl,panel_pol_activas, panel_pol_historicas, panel_info, panel_stro = itinerador_info.info_tabla_panel_cl(id_cliente)
    success_info_alta,info_productor, info_ramo, info_cia, info_form_pago_cl, info_ciclo_fact, info_estado_poliza = itinerador_info.separadores_info_cliente()
    success_info_alta_stro, estado_siniestro,tipo_siniestro = itinerador_info.separadores_info_stro()

    
    
    if succes_tabla_panel_cl == False:
        alerta = 'Error al Actualizar Panel del Cliente'
        flash(alerta)

    elif success_info_alta == False:
        alerta = 'Error Para el alta de cliente'
        flash(alerta)

    elif success_info_alta_stro == False:
        alerta = 'Error Para el alta de Siniestro'
        flash(alerta)

    if request.method == 'POST':

        if 'btn_cambio_prima' in request.form :
            itinerador.pan_mod_prima()
            pass

        if 'btn_cambio_estado' in request.form :
            itinerador.pan_mod_estado_pol()
            pass

        if 'btn_descripcion' in request.form :
            itinerador.pan_mod_pol_descripcion()
            pass

        if 'btn_alta_poliza' in request.form:
            itinerador.pan_insert_poliza()

            pass

        if 'btn_form_pago_cl' in request.form:
            itinerador.pan_mod_pol_form_pago()
            pass

        if 'btn_dir_particular' in request.form:
            itinerador.pan_mod_cli_dir_par()
            pass

        if 'btn_dir_legal' in request.form:
            itinerador.pan_mod_cli_dir_legal()
            pass

        if 'btn_mail' in request.form:
            itinerador.pan_mod_email()
            pass

        if 'btn_tel' in request.form:
            itinerador.pan_mod_cli_tel()
            pass

        if 'btn_CP' in request.form:
            itinerador.pan_mod_cli_CP()
            pass

        if 'btn_alta_stro' in request.form:
            alerta , error_msj = itinerador.alta_stro()
            print (alerta)
            print(error_msj)
            # content_length = request.content_length
            # return f"Tamaño de la solicitud POST: {content_length} bytes"

        return redirect(url_for('pan_cl.pan_cl_1', cliente_id=cliente_id))



    return render_template('todo/paneles/panel_cliente.html', panel_info = panel_info,
                           panel_pol_activas = panel_pol_activas, panel_pol_historicas = panel_pol_historicas,
                           panel_stro = panel_stro, info_productor = info_productor , info_ramo = info_ramo ,
                           info_cia = info_cia ,info_form_pago_cl = info_form_pago_cl ,
                           info_ciclo_fact = info_ciclo_fact ,info_estado_poliza = info_estado_poliza, 
                           tipo_siniestro = tipo_siniestro, estado_siniestro = estado_siniestro)

@bp.route('/buscador_dni', methods = ['GET','POST'])
@login_required
def buscador_dni():
    itinerador = Insert_tabla()
    prueba = Info_Panel_cl()

    succes , valor_provincia ,valores_est_civil= prueba.separadores_info_cl_nuevo()
    if succes == False:
        alerta = 'Error para dar de alta cliente'
        flash(alerta)

    if request.method == 'POST':
        if 'btn_buscar_tipo' in request.form:
            campos_buscar = ['buscador_texto' , 'buscador_tipo']
            _itinerador_post = ManejarFormulariosPost(request.form, campos_buscar)
            _itinerador_post.obtener_valores()

            
            values_insert = (_itinerador_post['buscador_tipo'], _itinerador_post['buscador_texto'])
            

            succes, tabla_cons_cliente_tipo = itinerador.select_sp('sp_buscar_cliente',values_insert)
            
            
            if succes == False:
                alerta = 'Error al Actualizar Panel del Cliente'
                flash(alerta)


            return render_template('todo/buscador_dni.html',
                                   tabla_cons_clientes_amostrar = tabla_cons_cliente_tipo,
                                   valores_est_civil = valores_est_civil ,valor_provincia =  valor_provincia)

        if 'panel_clientes' in request.form:
            cliente_id = request.form['panel_clientes']


            return redirect(url_for('pan_cl.pan_cl_1', cliente_id=cliente_id))

        if  'cliente_nuevo' in request.form:
            campos_buscar = ['id_dni','nom_apell','cuit','representante','fecha_nac','estado_civil','dir_part',
                             'dir_legal','codigo_postal','provincia','tel','mail','obs']

            _itinerador_post = ManejarFormulariosPost(request.form, campos_buscar)
            _itinerador_post.obtener_valores()
            _itinerador_post.convertir_vacios()

            print (_itinerador_post)
            values_insert_cliente_nuevo = (_itinerador_post['id_dni'],_itinerador_post['nom_apell'],_itinerador_post['cuit'],
                                           _itinerador_post['representante'],_itinerador_post['fecha_nac'],_itinerador_post['estado_civil'],
                                           _itinerador_post['dir_part'],_itinerador_post['dir_legal'],
                                           _itinerador_post['codigo_postal'],_itinerador_post['provincia'],
                                           _itinerador_post['tel'],_itinerador_post['mail'],_itinerador_post['obs'])
            cliente_id = _itinerador_post['id_dni']
            
     
            
            insertador = Insert_tabla()
            success, error_msj = insertador.insert_sp('SP_ALTA_CLIENTES', values_insert_cliente_nuevo)
            print (error_msj)
            if success :
                alerta = 'Realizado'
                flash(alerta)
            else:
                alerta = 'Error '
                flash(error_msj)

            pass
            return redirect(url_for('pan_cl.pan_cl_1', cliente_id=cliente_id))


    return render_template ('todo/buscador_dni.html', valores_est_civil = valores_est_civil ,
                            valor_provincia =  valor_provincia )
