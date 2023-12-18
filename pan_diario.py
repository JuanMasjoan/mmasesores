from os import error

from flask import (
    Blueprint, redirect, url_for, flash, render_template, request)

from Final.auth import login_required
from Final.class_metodo import ManejarFormulariosPost, ManejoFechas
from Final.def_mod_pan_diario import Info_Panel_Diario,ManejoFechas


bp = Blueprint('pan_diario', __name__)


@bp.route('/pan_diario', methods = ['GET','POST'])
@login_required
def pan_diario():
    itinerador_ = Info_Panel_Diario()
    succes_tabla_panel_diario, panel_pol_en_mora, panel_pol_avencer,panel_pol_vencida, panel_pol_ajustado_dolar = itinerador_.tablas_panel_diario()
    succes_tabla_panel_cl, info_panel_diario = itinerador_.info_panel_diario()
    

      
    
    if succes_tabla_panel_diario == False:
        alerta = 'Error al Actualizar Panel Diario'
        flash(alerta)
    if succes_tabla_panel_cl == False:
        alerta = 'Error para Actualizar Polizas'
        flash(alerta)
    
    
    if request.method == 'POST':
        
        if 'btn_cambio_estado' in request.form:
            
            campos_formulario = ['btn_cambio_estado','valor_estado']
            
            formulario = ManejarFormulariosPost(request.form, campos_formulario)
            formulario.obtener_valores()

            succes, resultado_fx =  itinerador_.upd_estado_polida(formulario.valores['btn_cambio_estado'],formulario.valores['valor_estado'])
           
            if succes == False:
                alerta = 'Error con Base de datos'
                flash(alerta)
            else:    
                if resultado_fx is not None:
                    alerta = 'Error Al procesar la actualizacion'
                    flash(alerta)
                else:
                    alerta = 'Modificacion Realizada'
                    flash(alerta)
            
            
            
            return  redirect (url_for('pan_diario.pan_diario'))

        if 'btn_renovacion' in request.form:
            
            alerta_1 , alerta_2 = itinerador_.up_pol_renovada()
            
        if 'redirect_panel_clientes' in request.form:
            campos_formulario = ['redirect_panel_clientes',]
            
            formulario = ManejarFormulariosPost(request.form, campos_formulario)
            formulario.obtener_valores()
            
            return redirect(url_for('pan_cl.pan_cl_1', cliente_id=formulario['redirect_panel_clientes']))
        
        if 'btn_upd_comentarios' in request.form:
            succes_tabla_panel_cl, resultado = itinerador_.upd_contacto_cliente()
            
            flash(resultado)            
        
        if 'btn_upd_vencimiento_comentario' in request.form:
            itinerador_.upd_contacto_cliente_vencimiento()
            
            
        
        return  redirect (url_for('pan_diario.pan_diario'))


    return render_template('todo/paneles/pan_diario.html', vw_mora = panel_pol_en_mora,
                            tabla_renovaciones = panel_pol_vencida,info_panel_diario = info_panel_diario,
                            tabla_a_renovaciones = panel_pol_avencer, panel_pol_ajustado_dolar = panel_pol_ajustado_dolar)

