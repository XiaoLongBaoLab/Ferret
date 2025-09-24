[Unit]
Description=Configure ACPI Wake devices for GPD WIN MAX 2

[Service]
ExecStart=/usr/libexec/gpd-winmax2-acpi-wake.py

[Install]
WantedBy=multi-user.target
