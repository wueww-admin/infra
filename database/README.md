# MySQL

Create PV

```
kind: PersistentVolume
apiVersion: v1
metadata:
  name: wueww-admin-mysql-pv
  labels:
    type: local
spec:
  storageClassName: manual
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/opt/kube/pv/wueww-admin-mysql"
```

```
helm fetch stable/mysql
helm template mysql-0.19.0.tgz --name mysql --set mysqlDatabase=wueww --set mysqlUser=wueww --set persistence.storageClass=manual | kubectl apply -f - -n wueww-admin
```

Import `database/schema.sql`.
