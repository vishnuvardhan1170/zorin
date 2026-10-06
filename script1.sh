#!/usr/bin/env bash
set -euo pipefail

echo "=== Python Lint & Format ==="

echo "Formatting app.py using black.."
black app.py

echo "Checking app.py using black.."
black --check app.py


echo "Running flake8 on app.py.."
flake8 app.py --max-line-length=120 --statistics

echo "Running mypy on app.py..."
mypy app.py --ignore-missing-imports

echo ""
echo "=== Helm Lint & Template ==="

echo "Linting helm..."
helm lint helm

echo "Templating helm..."
helm template my-app helm > /dev/null

echo ""
echo "=== Terraform Init, Validate & Format ==="

echo "Initializing tf/.."
terraform -chdir=tf init -backend=false

echo "Validating tf/.."
terraform -chdir=tf validate

echo "Checking format in tf/..."
terraform -chdir=tf fmt -check -diff

echo "Formatting tf/..."
terraform -chdir=tf fmt

echo ""
echo "✅ All checks passed." 
