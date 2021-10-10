import socket
import threading
import time
import sys
import random

ACCEPT_TIMEOUT = 5000  # ms
BUFFER_SZ = 100
used_ports = []
clients = 0


def generate_port():
  port = random.randint(0, 65535)
  if used_ports.count(port) > 0:
    return generate_port()
  used_ports.append(port)
  return port


client_worker_return_data = {}  # mutable


def accept_send_worker(s):
  c, a = s.accept()
  client_worker_return_data['accepted'] = (c, a)


def client_worker(port):
  global clients

  s = socket.socket(family=socket.AF_INET, type=socket.SOCK_STREAM)
  s.bind(("127.0.0.1", port))
  s.listen(1)

  clients += 1

  #  timeout?
  timer_th = threading.Thread(target=accept_send_worker, args=(s,))
  timer_th.start()

  con, addr = (None, None)
  for i in range(ACCEPT_TIMEOUT):  # interrupt sleep (sleep less, check for info between sleeping sessions)
    time.sleep(0.001)  # sleep less
    if 'accepted' in client_worker_return_data:  # check for info
      con, addr = client_worker_return_data['accepted']
      timer_th.join()
      break

  if con is None:
    s.close()
    clients -= 1
    return
  #  /timeout?

  attempts_left = 5
  con.send(b"Welcome to the number guessing game!\nEnter the range:")
  r = con.recv(BUFFER_SZ)  # range: str
  number = random.randint(int(r.split()[0]), int(r.split()[1]))
  con.send(f"You have {attempts_left} attempts".encode('utf8'))
  while True:
    guess = con.recv(BUFFER_SZ)

    if int(guess) == number:
      con.send(b"You win!")
      con.close()
      clients -= 1
      return
    if attempts_left == 0:
      con.send(b"You lost")
      con.close()
      clients -= 1
      return

    resp = "Greater" if int(guess) < number else "Less"
    con.send(f"You have {attempts_left} attempts\n".encode('utf8') + resp.encode('utf8'))
    attempts_left -= 1


if __name__ == '__main__':
  if len(sys.argv) != 2:
    print("Usage example: python server_lab4.py <port>")
    sys.exit(0)

  s = socket.socket(family=socket.AF_INET, type=socket.SOCK_STREAM)

  try:
    s.bind(("127.0.0.1", int(sys.argv[1])))
  except Exception as e:
    print("Error while binding to the specified port")
    sys.exit(0)

  s.listen(2)
  print(f'Starting the server on 127.0.0.1:{sys.argv[1]}')

  while True:
    try:
      print("Waiting for connection")
      con, addr = s.accept()
      if clients >= 2:
        print("Server is full")
        con.send(b"Server is full")
        con.close()
        continue

      print("Client connected")
      port = generate_port()
      client_th = threading.Thread(target=client_worker, args=(port,))
      client_th.start()
      con.send(str(port).encode('utf8'))
      con.close()

    except KeyboardInterrupt as ke:
      sys.exit(0)
