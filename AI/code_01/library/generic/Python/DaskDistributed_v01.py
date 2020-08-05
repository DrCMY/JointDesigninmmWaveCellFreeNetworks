def DaskDistributed(Option,n_workersx):       
    if Option=='m'    :
    # Option-1 (Manual)
        from dask.distributed import Client
        client = Client("tcp://127.0.0.1:8786")  # set up local cluster on your laptop
    elif Option=='a'   :
    # Option-2 (Automated)
        from dask.distributed import Client, LocalCluster
        cluster = LocalCluster(n_workers=n_workersx)
        client= Client(cluster)
        cluster.scheduler
        cluster.workers


"""
Option-1 (Manual)
After you manually create workers and if you do not close them (MS-DOS windows) but close Anaconda, you can reconnect to those workers via this option
In[4]: cluster.scheduler
Out[4]: <Scheduler: "tcp://127.0.0.1:7938" processes: 10 cores: 20>
It says processes:10, cores:20. It should be cores:5
"""