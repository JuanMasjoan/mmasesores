from flask import request

from Final.class_metodo import Insert_tabla, ManejarFormulariosPost ,ManejoFechas


class Info_Panel_Siniestro:
    def __init__(self,):
        self.e = Insert_tabla()

    def def_panel_siniestro (self, ):
        
        succes_siniestro_ful,panel_pol_en_mora = self.e.select_sp('vw_siniestro_full')
        print ('pipo')
        if succes_siniestro_ful == True :
            return panel_pol_en_mora
        
        else:
            pass