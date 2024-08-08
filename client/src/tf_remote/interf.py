from abc import ABC, abstractmethod
import requests as req
import multiprocessing as mp
import os, tomllib


class Connection():
    def __init__(self, api_base=None, std_path=os.environ['STD_PATH']) -> None:
        with open(std_path, 'rb') as f:
            self.std = tomllib.load(f)
        
        if api_base: self.std["api"]["base"] = api_base

    def get_status(self):
        try:
            resp = req.get(self.std["api"]["base"] + self.std["api"]["endpoints"]["status"])
            resp.raise_for_status()  # Raise an exception for HTTP errors (e.g., 404, 500)

            data = resp.json()  # Assuming the API returns JSON data
            return data

        except req.exceptions.RequestException as error:
            print(f"Error fetching data: {error}")
            return None  # Return None to indicate the request failed


class Interf(ABC):
    @abstractmethod
    def post():
        pass
    
    @abstractmethod
    def get():
        pass
    
    @abstractmethod    
    def put():
        pass
    
    @abstractmethod
    def delete():
        pass


class IData(Interf):
    def post():
        pass

    def get():
        pass
    
    def put():
        pass
    
    def delete():
        pass        


class IJob(Interf):
    def post():
        pass
    
    def read():
        pass
        
    def put():
        pass
    
    def delete():
        pass


def get_status(Connection):
    req.

    response = req.get(Connection.base)

        
