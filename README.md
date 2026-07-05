# K3s Swiss Army Lab – Setup Completo

## Objetivo

Montar un laboratorio local en Ubuntu con:

* IP fija en LAN
* Cluster Kubernetes ligero (k3s)
* Acceso desde otros dispositivos en la red
* Servicios útiles (vault, pdf tools, etc.)

---

# 1. Configurar IP fija en Ubuntu (WiFi)

## Ver conexión activa

```bash
nmcli connection show
```

Ejemplo:

```
DIGITEBRA-KXPx
```

## Asignar IP fija

```bash
nmcli connection modify "DIGITEBRA-KXPx" \
ipv4.method manual \
ipv4.addresses 192.168.1.50/24 \
ipv4.gateway 192.168.1.1 \
ipv4.dns "1.1.1.1 8.8.8.8"
```

## Aplicar cambios

```bash
nmcli connection down "DIGITEBRA-KXPx"
nmcli connection up "DIGITEBRA-KXPx"
```

## Verificar

```bash
hostname -I
```

Debe devolver:

```
192.168.1.50
```

---

## Importante

En el router:

* DHCP: `192.168.1.128 – 192.168.1.254`
* Tu IP: `192.168.1.50` (fuera del rango)

---

# 2. Instalar K3s

## Instalación limpia

```bash
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server \
--node-ip=192.168.1.50 \
--node-external-ip=192.168.1.50 \
--write-kubeconfig-mode 644" sh -
```

---

## Configurar kubectl

```bash
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $USER:$USER ~/.kube/config
```

---

## Verificar cluster

```bash
kubectl get nodes
kubectl get pods -A
```

---

# 3. Arquitectura del laboratorio

## Acceso

```text
http://192.168.1.50/
```

## Tipos de exposición

| Tipo     | Uso              |
| -------- | ---------------- |
| Ingress  | homepage, whoami |
| NodePort | apps reales      |

---

# 4. Servicios incluidos

> Basado en el dashboard de Homepage (`2-base/homepage/configmap.yaml`).

## Dashboard

* Homepage → `/`

## Test

* Whoami → `/whoami`

## Seguridad

* Vaultwarden → `:30080`

## PDFs

* Stirling PDF → `:30081`

## Automatización

* n8n → `:30083`

## Diagramas y dibujo

* draw.io → `:30084`
* Excalidraw → `:30085`

## Utilidades

* CyberChef → `:30086`
* IT-Tools → `:30087`

## Notas

* Memos → `:30088`

---

# 5. Despliegue

## Aplicar todo

```bash
./scripts/apply-all.sh
```

## Ver estado

```bash
kubectl get pods -A
kubectl get svc -A
kubectl get ingress -A
```

---

# 6. URLs finales

```text
http://192.168.1.50/            → Homepage
http://192.168.1.50/whoami      → Whoami

http://192.168.1.50:30080       → Vaultwarden
http://192.168.1.50:30081       → Stirling PDF
http://192.168.1.50:30083       → n8n
http://192.168.1.50:30084       → draw.io
http://192.168.1.50:30085       → Excalidraw
http://192.168.1.50:30086       → CyberChef
http://192.168.1.50:30087       → IT-Tools
http://192.168.1.50:30088       → Memos
```

---

# 7. Troubleshooting

## Ver logs

```bash
kubectl logs -n apps deployment/homepage
```

## Ver endpoints

```bash
kubectl get endpoints -A
```

## Reiniciar deployment

```bash
kubectl rollout restart deployment/<name> -n <namespace>
```

---

# 8. Buenas prácticas

* No usar subpaths para apps complejas (grafana, gitea)
* Usar NodePort para apps “reales”
* Mantener IP fija
* Testear conectividad antes de desplegar

---

# 9. Siguientes pasos

* Añadir:

  * linkding (bookmarks)
  * adguard (DNS)
* Implementar autenticación central (Authelia)
* Añadir almacenamiento persistente serio

---

# Resultado

Tienes un laboratorio:

* estable en WiFi
* accesible en red local
* con servicios útiles reales
* fácil de extender

---

## Nota final

Este setup está optimizado para:

* aprender Kubernetes
* montar servicios reales
* evitar problemas típicos de red doméstica

---

**Fin.**
