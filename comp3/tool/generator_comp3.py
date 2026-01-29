
def generate_record(record_len, fill_char):
    return fill_char * record_len

f = open('output.txt', 'wb')
len_list = [400, 500, 700, 900, 1000]
fill_list = ["A", "B", "C", "D", "E"]

for i in range(10):
    record_len = len_list[i % len(len_list)]
    fill_char = fill_list[i % len(fill_list)]
    f.write(str(record_len).zfill(4).encode('utf-8'))
    f.write(generate_record(record_len-4, fill_char).encode('utf-8'))
    
f.close()
