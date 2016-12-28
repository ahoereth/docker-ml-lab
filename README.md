# Docker Python 3 & Jupyter Environment

## Example usage
Expose jupyter notebook and lab at `localhost:8888` and `localhost:8889` respecitvely and mount the `/home/work/src` directory:

    docker run --name lab -v /host/work/src:/home/mia/src -p 8888:8888 -p 8889:8889 ahoereth/ml-lab

Enter its bash (in a new terminal):

    docker exec -it lab bash
