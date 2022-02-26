class Product:
    def __init__(self, title: str, price: float, image: str = None, url: str = None):
        self.title = title
        self.url = url
        self.image = image
        self.price = price
