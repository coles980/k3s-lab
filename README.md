# 🛠️ K3s Swiss Army Lab – Setup Completo

## 🎯 Objetivo

Montar un laboratorio local en Ubuntu con:

* IP fija en LAN
* Cluster Kubernetes ligero (k3s)
* Acceso desde otros dispositivos en la red
* Servicios útiles (vault, pdf tools, etc.)

---

# 1️⃣ Configurar IP fija en Ubuntu (WiFi)

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

## ⚠️ Importante

En el router:

* DHCP: `192.168.1.128 – 192.168.1.254`
* Tu IP: `192.168.1.50` ✔️ (fuera del rango)

---

# 2️⃣ Instalar K3s

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

# 3️⃣ Arquitectura del laboratorio

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

# 4️⃣ Servicios incluidos

## 🌐 Dashboard

* Homepage → `/`

## 🧪 Test

* Whoami → `/whoami`

## 🔐 Seguridad

* Vaultwarden → `:30080`

## 📄 PDFs

* Stirling PDF → `:30081`

## 📊 Observabilidad (parcial)

* Uptime Kuma
* Grafana (opcional)

---

# 5️⃣ Despliegue

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

# 6️⃣ URLs finales

```text
http://192.168.1.50/
http://192.168.1.50/whoami

http://192.168.1.50:30080   → Vaultwarden
http://192.168.1.50:30081   → PDF Tools
```

---

# 7️⃣ Troubleshooting

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

# 8️⃣ Buenas prácticas

* ❌ No usar subpaths para apps complejas (grafana, gitea)
* ✔️ Usar NodePort para apps “reales”
* ✔️ Mantener IP fija
* ✔️ Testear conectividad antes de desplegar

---

# 9️⃣ Siguientes pasos

* Añadir:

  * n8n (automatización)
  * linkding (bookmarks)
  * adguard (DNS)
* Implementar autenticación central (Authelia)
* Añadir almacenamiento persistente serio

---

# 🚀 Resultado

Tienes un laboratorio:

* estable en WiFi
* accesible en red local
* con servicios útiles reales
* fácil de extender

---

## 🧠 Nota final

Este setup está optimizado para:

✔ aprender Kubernetes
✔ montar servicios reales
✔ evitar problemas típicos de red doméstica

---

**Fin.**
