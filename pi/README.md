# Pi number

<h1 align="center">
    <img alt="cover" src=".github/cover.png" />
</h1>

## Compilação
* Para criar o arquivo e o documento[^1] basta digitar:
```
$ tex experiments_with_pi.ins 

# Generate data
$ docker build -t bench:debian .
$ docker run --name bench -it --rm -v /$(pwd)/generated:/bench/generated bench:debian

$ ./build.sh
```

* Caso deseja compilar o arquivo `experiments_with_pi.c` manualmente:
```
$ tex experiments_with_pi.ins 
$ gcc experiments_with_pi.c -lmpfr -lgmp -lpthread -o experiments_with_pi -D<MACROS>
```

| Macros                       | Definition[^2] |
|------------------------------|----------------|
| DEBUG                        |                |
| USE_MPFR                     |                |
| USE_MPF                      |                |
| USE_PTHREAD                  |                |
| NUMBER_THREADS               | nproc --all    |


E para executar o arquivo compilado:
```
$ experiments_with_pi <METHOD> <ERR>
```

| Method                              	| Err    	|
|-------------------------------------	|--------	|
| m (machin); t (takano); s (stormer) 	| Number 	|

[^1]: Para o documento é necessário instalar o pacote [`m_style`](https://github.com/guilhermeivo/m_style).

[^2]: Definições recomendadas.