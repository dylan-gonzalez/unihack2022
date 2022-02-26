import numbers


class Product:
    def __init__(self, title: str, price: float, source:str, image: str = None, url: str = None):
        if(type(price) != float):
            raise ValueError('Price must be of float')
        self.title = title
        self.url = url
        self.image = image
        self.price = price
        self.source = source