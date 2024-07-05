from diagrams import Cluster, Diagram, Edge
from diagrams.programming.flowchart import *
from diagrams.oci.governance import Groups
from diagrams.c4 import SystemBoundary

graph_attr = {
    "dpi":"300",
    # "size":"2000000",
    # "dim":"10",
    "beautify":"true",
    # "fontsize": "45",
    "fontcolor": "black",
    "pad":"0.02",
    # "compound":"true",
    # "colorscheme":"brbg10",
    # "smoothType":"graph_dist",
    # "Damping":"0.001",
    "layout": "dot", # neato dot twopi
    "clusterrank":"local",
    # "weight":"1",
    "nslimit1":"1000000",
    "searchsize":"2000",
    # "packMode":"node", # graph cluster node
    # "layout": "nato", # neato dot twopi
    # "mode": "major", # major KK sgd hier ipsep
    # "model":"shortpath", # shortpath circuit subset
    # "overlap":"prism0", # prism prism0 scalexy compress
    # "rankdir":"LR",
    # "pack":"true",
    "maxiter":"1000000",
    # "sep":"10",
    # "samplepoints":"30",
    "splines":"true"
}
node_attr = {
    # "color":"red",
    # "fontcolor": "black",
    # "colorscheme":"accent8",
}
edge_attr = {
    # "pad":"0",
    # "color":"black",
    # "fontcolor": "black",
    # "colorscheme":"accent8",
}

with Diagram(show=True, graph_attr=graph_attr, node_attr=node_attr, edge_attr=edge_attr,
    outformat="png", filename="./info/img/arch", # direction="TB"
    ) as diag:

    user = Groups("User")

    with SystemBoundary("Client",):
                
        with Cluster("Modeling input", ):
            input_user = [
                ManualInput("Search\nparameters"),
                ManualInput("Metamodel\narchitecture\nparameters"),
                ManualInput("Raw data"),
            ]
        
        model_desc = PredefinedProcess("Metamodel\ndescriptor")
        
        with Cluster("Metamodel\narchitecture"):
            h5_files = MultipleDocuments("Model\nfiles (.h5)")
            train_param = MultipleDocuments("Training\nparameters")
            meta_models = [
                train_param,
                h5_files,
                MultipleDocuments("Processed\ndata"),
            ]
        
        job_maker = Preparation("Job\nmaker")

        with Cluster("Metamodel\ntraining jobs"):
            meta_data = MultipleDocuments("Data\ncollections")
            meta_jobs = InternalStorage("Trainning\njobs")

        with Cluster("Interfaces:"):
            status_checker = PredefinedProcess("Status\nchecker")
            data_sender = PredefinedProcess("Data\nsender")
            job_sender = PredefinedProcess("Job\nsender")  
        

    with SystemBoundary("Server"):      
        with Cluster("Data"):
            server_data = MultipleDocuments("Job\ndata")
            server_index = Database("Job-data\nindex")
        
        with Cluster("Compute"):
            job_queue = InternalStorage("Job\nqueue")
            job_compute = PredefinedProcess("Job\ncompute")

        endpoint_status = Preparation("Status\nendpoint")
        endpoint_data = Preparation("Data\nendpoint")
        endpoint_job = Preparation("Job\nendpoint")


    # Client side connections
    user >> status_checker
    user >> input_user >> model_desc >> meta_models >> job_maker >> [meta_data, meta_jobs]
    meta_data >> data_sender
    meta_jobs >> job_sender

    # Side to side connections
    status_checker << Edge(label="", color="red") >> endpoint_status
    data_sender << Edge(label="", color="red") >> endpoint_data
    job_sender << Edge(label="", color="red") >> endpoint_job


    #  Server side connections
    endpoint_status << server_index
    endpoint_data >> [server_data, server_index]
    endpoint_job >> server_index

    [server_data, server_index] >> job_queue >> job_compute >> server_data