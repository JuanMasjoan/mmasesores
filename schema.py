usuarios = [
    """
    CREATE TABLE cartera_cliente.USER(
        id INT PRIMARY KEY AUTO_INCREMENT,
        username VARCHAR(50) UNIQUE NOT NULL,
        password VARCHAR(100) NOT NULL
    )
    """
]