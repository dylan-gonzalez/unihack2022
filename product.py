class Product:
    def __init__(self, title: str, price: float, image: str = None, description: str = None):
        self.title = title
        self.description = description
        self.image = image
        self.price = price