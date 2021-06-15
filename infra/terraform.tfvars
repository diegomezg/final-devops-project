prefix               = "teamthree"
resource_group_name  = "diego-gomez"
location             = "CentralUS"
node_count           = 3                # Min 3 nodes recommended for production
vm_size              = "Standard_D2_v2" # Hipster Shop requires min 6 Gb Ram
os_disk_size_gb      = 60               # Hipster Shop requires min 32 Gb disk
container_name       = "tstate"
storage_account_name = "team3demodou"