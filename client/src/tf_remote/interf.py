from abc import ABC, abstractmethod


class Connection():
    pass


class Interf(ABC):
    @abstractmethod
    def create():
        pass
    
    @abstractmethod
    def read():
        pass
    
    @abstractmethod    
    def update():
        pass
    
    @abstractmethod
    def delete():
        pass


def InterfData(Interf):
    def create():
        pass

    def read():
        pass
    
    def update():
        pass
    
    def delete():
        pass        


def InterfJob(Interf):
    def create():
        pass
    
    def read():
        pass
        
    def update():
        pass
    
    def delete():
        pass


def IntefStatus():
    def get():
        pass