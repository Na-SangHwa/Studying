game_board=['','','',
            '','','',
            '','','']

def empty_cells(board):
    cells=[] 
    for x, cell in enumerate(board):
        if cell =='':

            cells.append(x)
    return cells

def valid_move(x):
    return x in empty_cells(game_board)

def move(x, player):
    if valid_move(x):
        game_board[x]=player
        return False

def draw(board):
    for i, cell in enumerate(board):
        if i%3 == 0:
            print('\n------')
        print('|',cell,'|', end='')
    print('\n------')

def evaluate(board):
    if check_win(board, 'x'):
        score=1
    elif check_win(board, 'o'):
        score=-1
    else:
        score=0
    return score

def check_win(board, player):
    win_conf =[
                  [board[0],board[1],board[2]],
               [board[3],board[4],board[5]],
               [board[6],board[7],board[8]],
               [board[0],board[3],board[6]],
               [board[1],board[4],board[7]],
               [board[2],board[5],board[8]],
               [board[0],board[4],board[8]],
               [board[2],board[4],board[6]],
    ]
    return [player,player,player] in win_conf

def game_over(board):
    return check_win(board,'x') or check_win(board,'o')

def minimax(board,depth,maxPlayer):
    pos=-1
    if depth == 0 or len(empty_cells(board)) == 0 or game_over(board):
        return -1,evaluate(board)
    if maxPlayer:
        value = -10000
        for p in empty_cells(board):
            board[p]='x'

            x,score=minimax(board,depth-1,False)
            board[p]=''
            if score>value:
                value=score
                pos=p
    else:
        value = +10000
        for p in empty_cells(board):
            board[p] = 'o'

            x, score = minimax(board, depth - 1, True)
            board[p] = ''
            if score < value:
                value = score
                pos = p
    return pos,value

player='x'

while True:
    if player == 'x' :
        print("\n 컴퓨터 차례입니다.\n---------------")

        if len(empty_cells(game_board))==0 or game_over(game_board): #빈칸이 없거나 게임오버면
            break
        i,v=minimax(game_board,9,player=='x')
        move(i,player)
        
    elif player == 'o' :
        print("|0||1||2|\n|3||4||5|\n|6||7||8|"
              "\n x,max:comp, o,min:you")
        print("\n 사람 차례입니다.")
        draw(game_board)
        
        while True :
            if len(empty_cells(game_board)) == 0 or game_over(game_board):  # 빈칸이 없거나 게임오버면
                break
                
            inputs = int(input("0 ~ 8 중 원하는 위치 입력 : ")) #my turn
            if game_board[inputs] == '' :
               game_board[inputs] = 'o'
               break
            else :
               print("이미 들어 있는 위치입니다. 다시 입력하세요.")
        
    if player=='x':
        player='o'
    else:
        player='x'

if check_win(game_board,'x'):
    print('comp:x 승리')
elif check_win(game_board,'o'):
    print('you:o 승리')
else:
    print('비김')
