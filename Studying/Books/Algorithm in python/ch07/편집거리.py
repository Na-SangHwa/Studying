def edit_disatance(S,T,m,n):
    if m==0: return n
    if n==0: return m
    
    if S[m-1]==T[n-1]:
        return edit_disatance(S, T, m-1, n-1)
    
    return 1+min(edit_disatance(S, T, m, n-1),
             edit_disatance(S, T, m-1, n),
             edit_disatance(S, T, m-1, n-1))

def edit_disatance_mem(S,T,m,n,mem): # 메모제이션
    if m==0: return n
    if n==0: return m
    
    if mem[m-1][n-1]==None:
        if S[m-1]==T[n-1]:
            mem[m-1][n-1]=edit_disatance_mem(S, T, m-1, n-1, mem)
        
        else:
            mem[m-1][n-1] = 1+\
                min(edit_disatance_mem(S, T, m, n-1, mem),
                    edit_disatance_mem(S, T, m-1, n, mem),
                    edit_disatance_mem(S, T, m-1, n-1, mem))
    return mem[m-1][n-1]

S="tuesdaytuesdaytuesday"
T="thursdaythursdaythursday"
m=len(S)
n=len(T)
#print("문자열 : ",S,T)
print("편집거리(분할정복 ) = ",edit_disatance(S, T, m, n))

mem=[[None for _ in range(n)] for _ in range(m)]
dist=edit_disatance_mem(S, T, m, n, mem)
#print("편집거리(분할정복 ) = ",edit_disatance_mem(S, T, m, n, mem)) #더빠름
