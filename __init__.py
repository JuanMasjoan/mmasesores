import os

from dotenv import load_dotenv
from flask import Flask

load_dotenv()

def create_app():
    

    app = Flask(__name__)

 
    app.config.from_mapping(
        
        #SENDRIG_KEY=os.environ.get('SENDRIG_KEY'),
        SECRET_KEY='LAPRUEBALOCA',
        DATABASE_HOST=os.environ.get('FLASK_DATABASE_HOST'),
        DATABASE_PASSWORD=os.environ.get('FLASK_DATABASE_PASSWORD'),
        DATABASE_USER=os.environ.get('FLASK_DATABASE_USER'),
        DATABASE=os.environ.get('FLASK_DATABASE')  
    )   


    from . import db

    from . import auth 
    from . import index
    from . import pan_cl
    from . import pan_diario
    from . import contabilidad
    from . import pan_siniestro
    from . import creador_pdf
    
    from . import flsk_sql3_1

    app.register_blueprint(auth.bp)
    app.register_blueprint(index.bp)
    app.register_blueprint(pan_cl.bp)
    app.register_blueprint(flsk_sql3_1.bp)
    app.register_blueprint(pan_diario.bp)
    app.register_blueprint(contabilidad.bp)
    app.register_blueprint(pan_siniestro.bp)
    app.register_blueprint(creador_pdf.bp)
    
    

    db.init_app(app)

    @app.route('/hola')
    def hola():
        return 'chau ameo'
    
    return app