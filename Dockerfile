FROM python:3.6

ENV PY_USER pyuser
ENV PY_UID 1000
ENV HOME /home/$PY_USER

RUN useradd -m -s /bin/bash -N -u $PY_UID $PY_USER \
 && mkdir -p $HOME && chown $PY_USER $HOME \
 && mkdir -p /var/log/supervisor && chown $PY_USER /var/log/supervisor
WORKDIR $HOME

RUN pip install -q --no-cache-dir \
      jupyter \
      widgetsnbextension \
      matplotlib \
      numpy \
      pandas \
      xlrd \
      mysqlclient
#     jupyterlab
# RUN jupyter serverextension enable --py jupyterlab --sys-prefix
RUN jupyter nbextension enable --py widgetsnbextension --sys-prefix

RUN ln -s /usr/local/bin/python3 /usr/bin/python3 && \
    ln -s /usr/local/bin/python3.5 /usr/bin/python3.5

EXPOSE 8888
# EXPOSE 8889

ENTRYPOINT ["bash"]
CMD ["start.sh"]

COPY mplimporthook.py $HOME/.ipython/profile_default/startup/
COPY start.sh /usr/bin/

USER $PY_USER

ENV XDG_CACHE_HOME $HOME/.cache/
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot"
