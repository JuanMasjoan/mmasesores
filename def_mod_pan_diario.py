from flask import request

from Final.class_metodo import Insert_tabla, ManejarFormulariosPost ,ManejoFechas

class Info_Panel_Diario:
    def __init__(self,):
        self.e = Insert_tabla()
        self.f = ManejoFechas()


    def tablas_panel_diario (self,):
       
        fecha_ajustado_dolar =  self.f.fechas_180_antes()
        valor_ajustado_dolar = (fecha_ajustado_dolar,)
        fecha_refacturacion = self.f.fechas_30_dias()
        valor_refacturacion = (fecha_refacturacion,)
        
        succes,panel_pol_en_mora = self.e.select_sp('sp_panel_diario_1')
        succes2,panel_pol_avencer = self.e.select_sp('sp_panel_diario_2')
        succes3,panel_pol_vencida = self.e.select_sp('sp_panel_diario_3')
        # succes4,panel_pol_ajustado_dolar = self.e.select_sp('sp_panel_diario_4',valor_ajustado_dolar)
        succes5,panel_pol_refacturacion = self.e.select_sp('sp_polizas_refacturacion',valor_refacturacion)
        
   
        if succes == succes2 == succes3 == succes5:
            succes_tabla_panel_cl = True
            return succes_tabla_panel_cl, panel_pol_en_mora, panel_pol_avencer,panel_pol_vencida, panel_pol_refacturacion
        else:
            succes_tabla_panel_cl = False
            return succes_tabla_panel_cl,None,None,None, None

    def info_panel_diario(self,):
        succes,info_panel_diario = self.e.select_sp('sp_info_panel_diario_1')
        
        if succes == True:
            succes_tabla_panel_cl = True
            return succes_tabla_panel_cl, info_panel_diario
        else:
            succes_tabla_panel_cl = False
            return succes_tabla_panel_cl,None

    def upd_estado_polida (self, id_poliza, id_estado):
        
        values_insert= id_poliza, id_estado
        succes, result_fx = self.e.select_sp('sp_mod_estado_poliza',values_insert)
        
        if succes == True:
            if result_fx == [{'resultado': 1}]:
                succes_tabla_panel_cl = True
                return succes_tabla_panel_cl, None
            else:
                error_en_fx = 'Error al Procesar la funcion '
                succes_tabla_panel_cl = False
                return succes_tabla_panel_cl, error_en_fx
                  
        else:
            succes_tabla_panel_cl = False
            return succes_tabla_panel_cl,None   
        
    def up_pol_renovada (self,):
        
            campos_formulario = ['num_pol_nuev','id_productor','id_dni','id_cia','id_ramo','descrip',
                                 'fecha_baja','fecha_baja_pol_renovada','refacturacion','id_forma_pago_clientes','cbu_tc',
                                 'cantidad_cuotas','id_ciclo_facturacion','prima','valor_estado',
                                 'id_dni','num_pol_vieja','sa_ajustado_dolar','poliza_renov']                 

            formulario = ManejarFormulariosPost(request.form, campos_formulario)
            formulario.obtener_valores()
            formulario.convertir_nulos()
            formulario.convertir_vacios()
             
            estado_pol_vieja = '4'
            poliza_renovada = '1' 
            
            valor_insert_1 = (formulario.valores['num_pol_nuev'], formulario.valores['id_productor'], 
                            formulario.valores['id_dni'],formulario.valores['id_cia'],
                            formulario.valores['id_ramo'],formulario.valores['descrip'],
                            formulario.valores['fecha_baja'], formulario.valores['fecha_baja_pol_renovada'],
                            formulario.valores['refacturacion'],formulario.valores['id_forma_pago_clientes'],
                            formulario.valores['cbu_tc'],formulario.valores['cantidad_cuotas'],
                            formulario.valores['id_ciclo_facturacion'],formulario.valores['prima'],
                            formulario.valores['valor_estado'],formulario.valores['sa_ajustado_dolar'],
                            poliza_renovada,formulario.valores['num_pol_vieja'],estado_pol_vieja)

            success, error_msj = self.e.insert_sp('sp_alta_pol_renov',valor_insert_1)
             
            return success, error_msj

    def upd_contacto_cliente(self,):
        campos_formulario = ['fecha_ultimo_contacto','comentario_ajustado_dolar','btn_upd_comentarios']

        
        formulario = ManejarFormulariosPost(request.form, campos_formulario)
        formulario.obtener_valores()
        
        values_insert = (formulario['fecha_ultimo_contacto'],formulario['comentario_ajustado_dolar']
                         ,formulario['btn_upd_comentarios'])
        
        succes, result_sp = self.e.select_sp('sp_mod_contacto_cliente',values_insert)

        if succes == True:
            succes_tabla_panel_cl = True
            return succes_tabla_panel_cl, result_sp
        else:
            succes_tabla_panel_cl = False
            return succes_tabla_panel_cl,None 
    
    def upd_contacto_cliente_vencimiento(self,):
        
        fecha_para_vencimiento = self.f.fechas_180_dsp() 
        
        campos_formulario = ['fecha_ultimo_contacto','comentario_ajustado_dolar','btn_upd_vencimiento_comentario']

        
        formulario = ManejarFormulariosPost(request.form, campos_formulario)
        formulario.obtener_valores()
        
        values_insert = (formulario['fecha_ultimo_contacto'],formulario['comentario_ajustado_dolar']
                         ,formulario['btn_upd_vencimiento_comentario'], fecha_para_vencimiento)
        
        succes, result_sp = self.e.select_sp('sp_mod_contacto_cliente_vencimiento',values_insert)

 
        if succes == True:
            succes_tabla_panel_cl = True
            return succes_tabla_panel_cl, result_sp
        else:
            succes_tabla_panel_cl = False
            return succes_tabla_panel_cl,None
    
    def upd_fecha_refacturacion(self,):
        
        campos_formulario = ['nva_fecha_refacturacion','nva_prima','btn_upd_fecha_refacturacion']
        formulario = ManejarFormulariosPost(request.form, campos_formulario)
        formulario.obtener_valores()

        values_insert = (formulario.valores['btn_upd_fecha_refacturacion'],
            formulario.valores['nva_fecha_refacturacion'] ,formulario.valores['nva_prima'])
        
        succes, result_fx = self.e.select_sp('sp_upd_fecha_refact',values_insert)
        
        return succes , result_fx
        #succes, result_fx = self.e.select_sp('sp_mod_estado_poliza',values_insert)
    
    
      
        
          
                    
        