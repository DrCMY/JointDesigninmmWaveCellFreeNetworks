import time
def TimeDuration(start_time):        
    end_time = time.time()
    hours, rem = divmod(end_time-start_time, 3600)
    minutes, seconds = divmod(rem, 60)    
    timeduration="{:0>2}:{:0>2}:{:05.2f}".format(int(hours),int(minutes),seconds)       
    return timeduration