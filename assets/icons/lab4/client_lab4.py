import sys
import socket

BUFFER_SZ = 100


if __name__ == '__main__':
  if len(sys.argv) != 3:
    print("Usage example: python3 client_lab4.py <address> <port>")
    sys.exit()
  s = socket.socket(family=socket.AF_INET, type=socket.SOCK_STREAM)
  
  try:
    s.connect((sys.argv[1], int(sys.argv[2])))
  except Exception as e:
    print("Server is unavailable")
    sys.exit()
  message = s.recv(BUFFER_SZ)
  try:
    port = int(message)
  except Exception as e:
    print("Server is full")
    sys.exit()
  s.close()

  s = socket.socket(family=socket.AF_INET, type=socket.SOCK_STREAM)
  s.connect((sys.argv[1], port))
  msg_first = s.recv(BUFFER_SZ)
  print(msg_first.decode('utf8'))

  start, end = 2, 1
  while start > end:
    a, b = input().split()
    start = int(a)
    end = int(b)

  s.send(f'{start} {end}'.encode('utf8'))
  print(s.recv(BUFFER_SZ).decode('utf8'))
  while True:
    guess = input(">")
    s.send(str(guess).encode('utf8'))
    resp = s.recv(BUFFER_SZ)
    print(resp.decode('utf8'))
    if resp == b"You lost" or resp == b"You win!":
      s.close()
      break
