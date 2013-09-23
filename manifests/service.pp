
class centrify::service inherits centrify {
  
  # Error check for the dc_service ensure option 
  if ! ($dc_service_ensure in [ 'running', 'stopped' ]) {
    fail('dc_service_ensure parameter must be running or stopped')
  }
  
  # Error check for the ssh_service ensure option 
  if ! ($ssh_service_ensure in [ 'running', 'stopped' ]) {
    fail('ssh_service_ensure parameter must be running or stopped')
  }
  
}