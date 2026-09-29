<p align="center">
  <img src="docs/images/banner.svg" alt="ScriptPoblar" width="900"/>
</p>

<h1 align="center">ScriptPoblar</h1>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/github/license/GeiserX/ScriptPoblar" alt="License"></a>
</p>

<p align="center">Parallel CRM Control device provisioning</p>

---

An R script that makes CRM Control adopt a whole network of devices in parallel instead of one at a time.

## Quick start

You need R with `stringr`, the CRM Control install at `/usr/share/crmpoint`, and a `Dispositivos.csv` with a `Direcciones` column (one 10.x.x.x network per row). Set the four candidate passwords in [`script.R`](script.R) lines 38-41 and the working directory in line 1, then:

```bash
Rscript script.R
```

It expands every 10.x.x.x/24 range and runs `manage.pyo adopt` in parallel on all cores but four, so the host needs at least five cores. The script passes the CSV values to the shell unchecked: use a `Dispositivos.csv` you wrote yourself.

## Related projects

- [genieacs-container](https://github.com/GeiserX/genieacs-container): Helm chart and container for GenieACS TR-069
- [router-express](https://github.com/GeiserX/router-express): auto-configures client routers and syncs databases
- [services-isp](https://github.com/GeiserX/services-isp): automates common ISP operational tasks
- [statix](https://github.com/GeiserX/statix): ISP network statistics dashboard

## License

[GPL-3.0-or-later](LICENSE)
