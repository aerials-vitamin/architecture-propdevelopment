| № | Роль                 | Полномочия в Kubernetes (Примеры)                                                                 | Группы пользователей (Примеры) |
|---|----------------------|---------------------------------------------------------------------------------------------------|--------------------------------|
| 1 | `readonly-viewer`    | `get`, `list`, `watch` для большинства ресурсов (pods, services, deployments, etc.) во всех namespace | `bi-analysts`      |
| 2 | `developer`          | `get`, `list`, `watch`, `create`, `update`, `patch`, `delete` для (pods, services, deployments, configmaps, jobs, cronjobs) в *своих* namespace(ах) | `developers`                   |
| 3 | `cluster-configurator` | Полномочия `developer` + управление `namespaces`, `nodes` (get, list), `storageclasses`, `networkpolicies`. Ограниченный доступ к `secrets`. | `devops`, `operations`         |
| 4 | `security-auditor`   | `get`, `list`, `watch` для *всех* ресурсов, включая `secrets`, `roles`, `rolebindings`, `clusterroles`, `clusterrolebindings` на уровне кластера. | `security-specialists`         |
