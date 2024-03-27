## Usage instructions

This is intended to be run as a systemd system unit (as `root:root`) to have access to `/dev/bus/usb` devices when a user is not logged in. As such, the `build.sh` tool MUST be run as a rootful user (e.g. `sudo ./build.sh`) before enablement as a systemd service.

- Before running `build.sh` make sure to customize the bus id of the scanner you intend to use

- Run `sudo ./build.sh` to build and run the container for the first time

- Check for any errors with `tail -f insaned.log`

- Once the container is confirmed to be working as a rootful user then use the `artifacts/export.sh` to create a systemd unit file

- Customize the unit file before doing:

  - `sudo cp artifacts/container-insaned_srv.service /etc/systemd/system/`
  - `sudo systemctl daemon-reload; sudo systemctl enable --now container-insaned_srv.service`

- If you wish to export the running container to a tarball for backup purposes you may use:
  - "sudo artifacts/export.sh -t" for export to tarball
  - "sudo artifacts/import.sh" for re-import into docker/podman under the "insaned_srv" label
