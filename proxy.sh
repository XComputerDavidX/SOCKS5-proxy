#!/usr/bin/env bash

# === Config ===
PUBLIC_IP="xxx.xxx.xxx.xxx"  # Your server public IP (Must change)
SSH_PORT=7000
LOCAL_SOCKS_PORT=1080
SSH_USER="replace_with_username"     # Your SSH login username (Must change)
SSH_KEY="path/to/your/private/key"  # Path to your SSH key (Must change)
LOG_FILE="$HOME/proxy.log"    # Log file path
PID_FILE="$HOME/proxy.pid"     # PID file path

# Function to Log Messages with Timestamps
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Function to Start SSH SOCKS5 Proxy
start_proxy() {
    log_message "[*] Starting SSH SOCKS5 proxy..."
    log_message "[*] Configuring proxy settings:"
    log_message "    Public IP: $PUBLIC_IP"
    log_message "    SSH Port: $SSH_PORT"
    log_message "    Local SOCKS Port: $LOCAL_SOCKS_PORT"
    log_message "    SSH User: $SSH_USER"
    log_message "    SSH Key: $SSH_KEY"
    
    # Start the SSH proxy and log stderr
    log_message "[*] Initiating SSH connection..."
    ssh -D $LOCAL_SOCKS_PORT -C -q -N -i "$SSH_KEY" "$SSH_USER@$PUBLIC_IP" -p "$SSH_PORT" >> "$LOG_FILE" 2>&1 &
    SSH_PID=$!

    # Save the PID to a file
    echo $SSH_PID > "$PID_FILE"

    sleep 2  # Allow time for the SSH connection to establish

    if ps -p $SSH_PID > /dev/null; then
        log_message "[*] SSH tunnel is running (PID: $SSH_PID)."
        log_message "[*] Proxy is now active."
        log_message "[*] Checking connection status..."
        check_connection
    else
        log_message "[!] Failed to establish SSH connection."
        exit 1
    fi
}

# Function to Check Connection Status 
check_connection() {
    # Check if the proxy is working with a specific website
    if curl -s --connect-timeout 2 --socks5 "127.0.0.1:$LOCAL_SOCKS_PORT" "http://api.ipify.org" > /dev/null; then
        log_message "[*] Proxy is functioning properly."
    else
        log_message "[!] Unable to connect through proxy."
        return
    fi
    
    # Ping google.com to test connectivity
    PING_RESULT=$(ping -c 1 google.com)
    if [ $? -eq 0 ]; then
        log_message "[*] Ping to google.com succeeded:"
        log_message "$PING_RESULT"
    else
        log_message "[!] Ping to google.com failed."
    fi
}

# Function to Stop SSH SOCKS5 Proxy 
stop_proxy() {
    if [ ! -f "$PID_FILE" ]; then
        log_message "[!] No SSH proxy is running (PID file does not exist)."
        return
    fi

    SSH_PID=$(cat "$PID_FILE")

    log_message "[*] Stopping SSH SOCKS5 proxy (PID: $SSH_PID)..."
    if kill $SSH_PID 2>/dev/null; then
        log_message "[*] Proxy stop signal sent successfully."
        sleep 1  # Wait a moment for the process to terminate
        if ps -p $SSH_PID > /dev/null; then
            log_message "[!] Proxy did not stop successfully (PID still exists)."
        else
            log_message "[*] Proxy stopped successfully."
            rm -f "$PID_FILE"  # Remove the PID file after stopping
        fi
    else
        log_message "[!] Failed to stop the proxy. The process may not exist."
    fi
}

# Trap Ctrl+C to Stop Proxy 
trap stop_proxy SIGINT

# Main Logic 
if [[ "$1" == "start" ]]; then
    start_proxy
elif [[ "$1" == "stop" ]]; then
    stop_proxy
else
    log_message "Usage: $0 {start|stop}"
    exit 1
fi
