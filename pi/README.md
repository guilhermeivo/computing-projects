# Pi number

## Configuração inicial
```
$ apt-get install libgmp3-dev libmpfr-dev
```

## Compilação
* Para criar o arquivo e o documento (para o documento é necessário instalar o [`m_style`](#configuração-do-pacote-m_style)) basta digitar:
```
$ ./build.sh
```

* Caso deseja compilar o arquivo `experiments_with_pi.c` manualmente:
```
$ tex experiments_with_pi.ins 
$ gcc experiments_with_pi.c -Wall -lmpfr -lgmp -o experiments_with_pi -D DEBUG
```

E para executar o arquivo compilado:
```
$ experiments_with_pi <METHOD> <ERR>
```

| Method                              	| Err    	|
|-------------------------------------	|--------	|
| m (machin); t (takano); s (stormer) 	| Number 	|

## Configuração do pacote m_style
```
$ git clone https://github.com/guilhermeivo/m_style/
$ ./SAVE.sh
```