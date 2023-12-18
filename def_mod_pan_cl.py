from flask import (
    Blueprint, redirect, url_for, flash, render_template, request
)
from Final.class_metodo import Insert_tabla , ManejarFormulariosPost
from Final.db import get_db
from Final.auth import login_required
import zlib, base64



class Info_Panel_cl:
    def __init__(self,):
        self.e = Insert_tabla()
    
    def separadores_info_cliente(self,):
        
        info = self.e.select_sp('sp_info_inser_poliza')
        success_info_alta, data = info

        indice_separador = [i for i, d in enumerate(data) if d.get('separador') == 'SEPARADOR']
        
        if len(indice_separador) >= 6:
            partes = [data[indice_separador[i] + 1:indice_separador[i + 1]] for i in range(5)]

            partes.append(data[indice_separador[5] + 1:])

            info_productor, info_ramo, info_cia, info_form_pago_cl, info_ciclo_fact, info_estado_poliza = partes

            return success_info_alta,info_productor, info_ramo, info_cia, info_form_pago_cl, info_ciclo_fact, info_estado_poliza 
        else:
            print("No se encontraron suficientes separadores en los datos para dividir en  partes.")
            return success_info_alta,None, None , None, None , None, None

    def info_tabla_panel_cl(self,id_cliente):
            
        succes,panel_pol_activas = self.e.select_sp('sp_panel_cliente_pol', id_cliente)
        succes2, panel_pol_historicas = self.e.select_sp('sp_panel_cliente_pol2', id_cliente)
        succes3, panel_info = self.e.select_sp('sp_panel_cliente_info', id_cliente)
        succes4, panel_stro = self.e.select_sp('sp_panel_cliente_siniestro', id_cliente)
        

        
        if succes == succes2 == succes3 == succes4:
            succes_tabla_panel_cl = True
            return succes_tabla_panel_cl,panel_pol_activas, panel_pol_historicas, panel_info, panel_stro
        else:
            succes_tabla_panel_cl = False
            return succes_tabla_panel_cl,None,None,None,None
    
    def separadores_info_cl_nuevo(self,):
        
        self.info = self.e.select_sp('sp_info_inser_cliente')
        
        success_info_alta, data = self.info

        indice_separador = [i for i, d in enumerate(data) if d.get('separador') == 'SEPARADOR']
        
        if len(indice_separador) >= 2:
            partes = [data[indice_separador[i] + 1:indice_separador[i + 1]] for i in range(1)]

            partes.append(data[indice_separador[1] + 1:])

            info_provincia, info_esrado_civil= partes

            return success_info_alta,info_provincia, info_esrado_civil
        else:
            print("No se encontraron suficientes separadores en los datos para dividir en  partes.")
            return success_info_alta,None, None 

    def separadores_info_stro(self,):
        
        self.info = self.e.select_sp('sp_info_inser_stro')
        
        success_info_alta, data = self.info

        indice_separador = [i for i, d in enumerate(data) if d.get('separador') == 'SEPARADOR']
        
        if len(indice_separador) >= 2:
            partes = [data[indice_separador[i] + 1:indice_separador[i + 1]] for i in range(1)]

            partes.append(data[indice_separador[1] + 1:])

            estado_siniestro, tipo_siniestro= partes

            return success_info_alta,estado_siniestro, tipo_siniestro
        else:
            print("Error al cargar opciones de siniestro.")
            return success_info_alta,None, None 
       
#@login_required
class DefMoDPanCl:
    def __init__(self, cliente_id):
        self.cliente_id = cliente_id    
        self.itinerador = Insert_tabla()
            
    def pan_mod_pol_descripcion (self,):
        
        descripcion = request.form ['descripcion']
        id_pol = request.form ['btn_descripcion']

        values_insert = (id_pol, descripcion)
        success, error_msj = self.itinerador.insert_sp('sp_mod_descrip', values_insert)
        
        if success :
            alerta = 'Realizado'
            flash(alerta)
        else:
            alerta = 'Error '

        return alerta
    
    def pan_mod_pol_form_pago(self):
            id_forma_pago_cl = request.form ['form_pago_cl']
            id_pol = request.form ['btn_form_pago_cl']

            values_insert=(id_pol, id_forma_pago_cl)            
            success, error_msj = self.itinerador.insert_sp('sp_mod_form_pago', values_insert)

            return error_msj
        
    def pan_insert_poliza(self,):
        
        poliza = request.form ['id_poliza']
        productor = request.form ['id_productor']
        cia= request.form ['id_cia']
        ramo= request.form ['id_ramo']
        fecha_alta= request.form ['fecha_alta']
        fecha_baja= request.form ['fecha_baja']
        fecha_refacturacion= request.form ['fecha_refacturacion']
        form_pago= request.form ['id_form_pago']
        cbu_tc= request.form ['cbu_tc']
        cuotas= request.form ['cuotas']
        ciclo_facturacion= request.form ['id_ciclo_facturacion']
        prima= request.form ['prima']
        estado_poliza= request.form ['id_estado_poliza']              
        ajustado_dolar = '1 ' if 'ajustado_dolar' in request.form else '0'
        descripcion_poliza= request.form ['descripcion_poliza']    
            
            
        if not fecha_refacturacion:
            fecha_refacturacion = fecha_baja
        if not cbu_tc:
            cbu_tc = None
        if not descripcion_poliza:
            descripcion_poliza = 'null'

        values_insert_alta_poliza = (poliza,productor,self.cliente_id,cia,ramo,descripcion_poliza,fecha_alta,fecha_baja,
                                    fecha_refacturacion, form_pago,  cuotas, ciclo_facturacion, prima,
                                    estado_poliza, ajustado_dolar,cbu_tc)
        
        
      
        print (values_insert_alta_poliza)     
        success, error_msj = self.itinerador.insert_sp('SP_ALTA_POLIZA',values_insert_alta_poliza)

        if success :
            alerta = 'Realizado'
            flash(alerta)
        else:
            alerta = 'Error '
            flash(error_msj)
        
        return error_msj

    def pan_mod_estado_pol(self,):
        valor_estado = request.form ['id_estado_poliza']
        id_pol = request.form ['btn_cambio_estado']

        values_insert = ( id_pol, valor_estado)
        success, error_msj = self.itinerador.insert_sp('sp_mod_estado', values_insert)

        if success :
            alerta = 'Realizado'
            flash(alerta)
        else:
            alerta = 'Error '
            flash(error_msj)
        
        return error_msj

    def pan_mod_prima(self,):
        cambio_prima = request.form ['cambio_prima']
        id_pol = request.form ['btn_cambio_prima']

        values_insert = ( id_pol, cambio_prima)
        success, error_msj = self.itinerador.insert_sp('sp_mod_prima', values_insert)
        
        if success :
            alerta = 'Realizado'
            flash(alerta)
        else:
            alerta = 'Error '
            flash(error_msj)
            
        return error_msj
    
    def pan_mod_cli_dir_par(self,):
        dir_particular = request.form ['dir_particular']
        cod_clave = '1'
        values_upd = (cod_clave, self.cliente_id, dir_particular)
        success, error_msj = self.itinerador.insert_sp('sp_mod_cliente', values_upd)
        
        if success :
            alerta = 'Realizado'
            flash(alerta)
        else:
            alerta = 'Error '
            flash(error_msj)
            
        return error_msj

    def pan_mod_cli_dir_legal(self,):
        dir_legal = request.form [ 'dir_legal']
        cod_clave = '2'
        values_upd = (cod_clave,self.cliente_id, dir_legal)
        
        success, error_msj = self.itinerador.insert_sp('sp_mod_cliente', values_upd)
        
        
        if success :
            alerta = 'Realizado'
            flash(alerta)
        else:
            alerta = 'Error '
            flash(error_msj)
            
            
        return error_msj    

    def pan_mod_cli_CP(self,):
        CP = request.form [ 'CP']
        cod_clave = '3'
        values_upd = (cod_clave,self.cliente_id, CP)
        
        success, error_msj = self.itinerador.insert_sp('sp_mod_cliente', values_upd)
        
        if success :
            alerta = 'Realizado'
            flash(alerta)
        else:
            alerta = 'Error '
            flash(error_msj)
                
        return error_msj   
    
    def pan_mod_cli_tel(self,):
        Tel = request.form [ 'Tel']
        cod_clave = '4'
        values_upd = (cod_clave,self.cliente_id, Tel)
        
        success, error_msj = self.itinerador.insert_sp('sp_mod_cliente', values_upd)
        
        if success :
            alerta = 'Realizado'
            flash(alerta)
        else:
            alerta = 'Error '
            flash(error_msj)
                   
        return error_msj   

    def pan_mod_email(self,):
        
        mail = request.form [ 'mail']
        cod_clave = '5'
        values_upd = (cod_clave,self.cliente_id, mail)
        
        success, error_msj = self.itinerador.insert_sp('sp_mod_cliente', values_upd)
        
        if success :
            alerta = 'Realizado'
            flash(alerta)
        else:
            alerta = 'Error '
            flash(error_msj)
                   
        return error_msj   

    def alta_stro(self,):
            
        campos_formulario = ['numero_siniestro','id_poliza_stro','tipo_siniestro_','estado_siniestro_','fecha_siniestro',
                                'hora_siniestro','ubicacion_siniestr','descripcion_siniestro','comentarios_siniestro']
        
        formulario = ManejarFormulariosPost(request.form, campos_formulario)
        formulario.obtener_valores()
        formulario.convertir_vacios()
        # descripcion_siniestro = zlib.compress(formulario.valores['descripcion_siniestro'].encode('utf-8'))
        # descripcion_siniestro_ = base64.b64encode(descripcion_siniestro)

        
        valor_insert = [formulario.valores['numero_siniestro'],formulario.valores['id_poliza_stro'],formulario.valores['tipo_siniestro_'],
                        formulario.valores['estado_siniestro_'],formulario.valores['fecha_siniestro'],formulario.valores['descripcion_siniestro'],
                        formulario.valores['comentarios_siniestro'],formulario.valores['hora_siniestro'],
                        formulario.valores['ubicacion_siniestr']]
        
        success, error_msj = self.itinerador.insert_sp('sp_insertar_siniestro',valor_insert)
        
        if success :
            alerta_sp = True
        else:
            alerta_sp = False   
            
        return alerta_sp, error_msj
  

