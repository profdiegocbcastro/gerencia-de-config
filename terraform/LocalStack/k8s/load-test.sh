#!/bin/bash
echo "Enviando requests simultaneos..."
for i in {1..500000}; do
  echo "Request $i" 
  curl -s http://localhost:3000/alunos > /dev/null &
done
wait
echo "Feito. Acompanhe o escalonamento:"
echo "  kubectl get hpa -n cefet -w"
echo "  kubectl get pods -n cefet -w"