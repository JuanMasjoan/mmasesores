from flask import (
    Blueprint, redirect, url_for, flash, render_template, request
)
from Final.class_metodo import Insert_tabla , ManejarFormulariosPost
from Final.db import get_db
from Final.auth import login_required
import zlib, base64

class Consultas_contabilida:
    def __init__(self):
        self.selector = Insert_tabla()
        
        
    def consulta_vista_cartera_x_ramo(self,):
        campos_formulario = ['valor_ramo','buscador_ramo','valor_cia','buscador_cia']
        formulario = ManejarFormulariosPost(request.form, campos_formulario)
        formulario.obtener_valores()
        
        
        if formulario['buscador_ramo'] == 'on' and formulario['buscador_cia'] == 'on':
            flash('Debe elegir uno de los 2 filtros') 
        
        else:
            if formulario['buscador_cia'] == 'on':
                indice_sp = '1'
                values_buscar = (indice_sp,formulario['valor_ramo'],None)

                succes , count_elementos, elementos = self.selector.select_sp_2_resultados('sp_consulta_cartera_personalizada',values_buscar)
                if succes == True:
                    
                    return  count_elementos, elementos
                    
                else:
                    flash ('Error al buscar datos solicitados') 
                    
            elif  formulario['buscador_ramo'] == 'on' :    
                indice_sp = '2'
                values_buscar = (indice_sp, None, formulario['valor_cia'])
                succes , count_elementos, elementos = self.selector.select_sp_2_resultados('sp_consulta_cartera_personalizada',values_buscar)
                
                if succes == True:
                    
                    return  count_elementos, elementos
                else:
                    flash ('Error al buscar datos solicitados') 
 
            else:
                indice_sp = '3'
                values_buscar = (indice_sp, formulario['valor_ramo'], formulario['valor_cia'])
                succes , count_elementos, elementos = self.selector.select_sp_2_resultados('sp_consulta_cartera_personalizada',values_buscar)
                
                if succes == True:
                    return  count_elementos, elementos
                
                else:
                    flash ('Error al buscar datos solicitados') 
 
    def actualizar_cobro(self,):
        id_factura = []
        id_factura = request.form['btn_pagado']
        
        values_insert = (id_factura,)        
        success, datos = self.selector.insert_sp('sp_actualizar_cobro',values_insert)
        return redirect( url_for('contabilidad.facturas_cia'))