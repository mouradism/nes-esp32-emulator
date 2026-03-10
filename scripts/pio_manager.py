#!/usr/bin/env python3
"""
PlatformIO Build and Upload Script for NES Emulator on ESP32
Provides convenient commands for building, uploading, and monitoring the project.
"""

import subprocess
import sys
import os
from pathlib import Path

# Colors for terminal output
class Colors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'

def print_header(message):
    print(f"\n{Colors.HEADER}{Colors.BOLD}{'='*60}{Colors.ENDC}")
    print(f"{Colors.HEADER}{Colors.BOLD}{message:^60}{Colors.ENDC}")
    print(f"{Colors.HEADER}{Colors.BOLD}{'='*60}{Colors.ENDC}\n")

def print_success(message):
    print(f"{Colors.OKGREEN}? {message}{Colors.ENDC}")

def print_error(message):
    print(f"{Colors.FAIL}? {message}{Colors.ENDC}")

def print_info(message):
    print(f"{Colors.OKCYAN}? {message}{Colors.ENDC}")

def run_command(command, description):
    """Run a shell command and handle errors"""
    print_info(f"{description}...")
    try:
        result = subprocess.run(command, shell=True, check=True, 
                              capture_output=False, text=True)
        print_success(f"{description} completed")
        return True
    except subprocess.CalledProcessError as e:
        print_error(f"{description} failed")
        return False

def check_platformio():
    """Check if PlatformIO is installed"""
    try:
        subprocess.run(["pio", "--version"], check=True, 
                      capture_output=True, text=True)
        return True
    except (subprocess.CalledProcessError, FileNotFoundError):
        return False

def install_platformio():
    """Install PlatformIO"""
    print_header("Installing PlatformIO")
    print_info("Installing PlatformIO via pip...")
    return run_command("pip install platformio", "PlatformIO installation")

def build_project():
    """Build the project"""
    print_header("Building Project")
    return run_command("pio run", "Build")

def upload_project(port=None):
    """Upload to ESP32"""
    print_header("Uploading to ESP32")
    cmd = "pio run -t upload"
    if port:
        cmd += f" --upload-port {port}"
    return run_command(cmd, "Upload")

def monitor_serial(baudrate=115200):
    """Monitor serial output"""
    print_header("Serial Monitor")
    print_info("Press Ctrl+C to exit monitor")
    cmd = f"pio device monitor -b {baudrate}"
    subprocess.run(cmd, shell=True)

def clean_project():
    """Clean build files"""
    print_header("Cleaning Project")
    return run_command("pio run -t clean", "Clean")

def list_devices():
    """List connected devices"""
    print_header("Connected Devices")
    subprocess.run("pio device list", shell=True)

def update_libraries():
    """Update project libraries"""
    print_header("Updating Libraries")
    return run_command("pio lib update", "Library update")

def full_build_and_upload(port=None):
    """Clean, build, and upload"""
    print_header("Full Build and Upload")
    if not clean_project():
        return False
    if not build_project():
        return False
    if not upload_project(port):
        return False
    print_success("Full build and upload completed!")
    return True

def show_menu():
    """Show interactive menu"""
    print_header("NES Emulator on ESP32 - PlatformIO Manager")
    print("1. Build project")
    print("2. Upload to ESP32")
    print("3. Build and upload")
    print("4. Monitor serial output")
    print("5. Clean build files")
    print("6. List connected devices")
    print("7. Update libraries")
    print("8. Full rebuild and upload")
    print("9. Install PlatformIO")
    print("0. Exit")
    print()

def main():
    """Main function"""
    # Check if PlatformIO is installed
    if not check_platformio():
        print_error("PlatformIO is not installed!")
        choice = input("Would you like to install it now? (y/n): ")
        if choice.lower() == 'y':
            if install_platformio():
                print_success("PlatformIO installed successfully!")
            else:
                print_error("Failed to install PlatformIO")
                sys.exit(1)
        else:
            print_info("Please install PlatformIO manually: pip install platformio")
            sys.exit(1)
    
    # Interactive mode if no arguments
    if len(sys.argv) == 1:
        while True:
            show_menu()
            choice = input("Select option: ").strip()
            
            if choice == '1':
                build_project()
            elif choice == '2':
                port = input("Enter port (or press Enter for auto-detect): ").strip()
                upload_project(port if port else None)
            elif choice == '3':
                port = input("Enter port (or press Enter for auto-detect): ").strip()
                if build_project():
                    upload_project(port if port else None)
            elif choice == '4':
                baudrate = input("Enter baud rate (default 115200): ").strip()
                monitor_serial(int(baudrate) if baudrate else 115200)
            elif choice == '5':
                clean_project()
            elif choice == '6':
                list_devices()
            elif choice == '7':
                update_libraries()
            elif choice == '8':
                port = input("Enter port (or press Enter for auto-detect): ").strip()
                full_build_and_upload(port if port else None)
            elif choice == '9':
                install_platformio()
            elif choice == '0':
                print_info("Goodbye!")
                break
            else:
                print_error("Invalid option")
            
            input("\nPress Enter to continue...")
    
    # Command-line mode
    else:
        command = sys.argv[1].lower()
        
        if command == 'build':
            build_project()
        elif command == 'upload':
            port = sys.argv[2] if len(sys.argv) > 2 else None
            upload_project(port)
        elif command == 'monitor':
            baudrate = int(sys.argv[2]) if len(sys.argv) > 2 else 115200
            monitor_serial(baudrate)
        elif command == 'clean':
            clean_project()
        elif command == 'devices':
            list_devices()
        elif command == 'update':
            update_libraries()
        elif command == 'full':
            port = sys.argv[2] if len(sys.argv) > 2 else None
            full_build_and_upload(port)
        elif command == 'install':
            install_platformio()
        else:
            print(f"Usage: {sys.argv[0]} [build|upload|monitor|clean|devices|update|full|install]")
            sys.exit(1)

if __name__ == "__main__":
    main()
