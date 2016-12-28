FROM python:3.5

ENV PY_USER mia
ENV PY_UID 1000
ENV HOME /home/$PY_USER
ENV TINI_VERSION v0.13.2

RUN useradd -m -s /bin/bash -N -u $PY_UID $PY_USER \
 && mkdir -p $HOME && chown $PY_USER $HOME \
 && mkdir -p /var/log/supervisor && chown $PY_USER /var/log/supervisor
WORKDIR $HOME

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini.asc /tini.asc
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 \
 && gpg --verify /tini.asc
RUN chmod +x /tini

RUN pip install -q --no-cache-dir \
      jupyter \
      jupyterlab \
      widgetsnbextension \
      matplotlib \
      numpy \
      pandas \
      xlrd \
      mysqlclient
RUN jupyter serverextension enable --py jupyterlab --sys-prefix \
 && jupyter nbextension enable --py widgetsnbextension --sys-prefix

RUN ln -s /usr/local/bin/python3 /usr/bin/python3 && \
    ln -s /usr/local/bin/python3.5 /usr/bin/python3.5

EXPOSE 8888
EXPOSE 8889

ENTRYPOINT ["/tini", "--"]
CMD ["start.sh"]

COPY mplimporthook.py $HOME/.ipython/profile_default/startup/
COPY start.sh /usr/bin/

USER $PY_USER

ENV XDG_CACHE_HOME $HOME/.cache/
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot"
