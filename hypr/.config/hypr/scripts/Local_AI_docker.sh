#!/bin/bash

# Define the path to your docker-compose file's directory
# **NOTE:** Change this to the actual path of your project
PROJECT_DIR="/home/stick/Code/Locally_AI_Docker"

# Define the application URL
APP_URL="http://localhost:3000"

# --- Go to project directory ---
cd "$PROJECT_DIR" || {
  echo "Error: Project directory not found: $PROJECT_DIR"
  exit 1
}

# --- Check Docker Compose Status ---
# 'docker compose ps -q' lists the IDs of running containers for this project.
# The 'wc -l' counts the number of lines (containers).
RUNNING_CONTAINERS=$(docker compose ps -q | wc -l)

if [ "$RUNNING_CONTAINERS" -gt 0 ]; then
  # --- Action: STOP ---
  echo "Containers are running ($RUNNING_CONTAINERS detected). Stopping Docker Compose..."

  # Stop and remove containers, networks, and volumes
  docker compose down

  if [ $? -eq 0 ]; then
    echo "Docker Compose stopped successfully."
  else
    echo "Error: Docker Compose failed to stop."
  fi

else
  # --- Action: START ---
  echo "Containers are stopped. Starting Docker Compose project..."

  # Start Docker Compose services in detached mode (-d)
  docker compose up -d

  if [ $? -eq 0 ]; then
    echo "Docker Compose started successfully. Opening browser..."
    # Open the URL in the default browser
    xdg-open "$APP_URL" &
  else
    echo "Error: Docker Compose failed to start."
  fi
fi
