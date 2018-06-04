### Getting Started
```
1. docker build -t bryancy/a1_server .
2. docker run -it -v $(pwd):/home/a1/app -p 8899:5000 --name web bryancy/a1_server
```
