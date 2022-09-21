# Deploy gitea with kustomize

Default deployment in *gitea* namespace.

This manifest expects you already set a default storage class.
if not, this can be set by patching:

~~~
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: gitea
spec:
  storageClassName: {STORAGE_CLASS}
~~~

This manifest expects traefik as Ingress controller.

The app.ini file is given as templates a must be overriden.