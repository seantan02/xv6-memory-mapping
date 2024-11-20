
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 40 c6 21 80       	mov    $0x8021c640,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 70 30 10 80       	mov    $0x80103070,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 c5 10 80       	mov    $0x8010c554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 80 86 10 80       	push   $0x80108680
80100051:	68 20 c5 10 80       	push   $0x8010c520
80100056:	e8 b5 44 00 00       	call   80104510 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c 0c 11 80       	mov    $0x80110c1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c 0c 11 80 1c 	movl   $0x80110c1c,0x80110c6c
8010006a:	0c 11 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 0c 11 80 1c 	movl   $0x80110c1c,0x80110c70
80100074:	0c 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c 0c 11 80 	movl   $0x80110c1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 87 86 10 80       	push   $0x80108687
80100097:	50                   	push   %eax
80100098:	e8 43 43 00 00       	call   801043e0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 0c 11 80       	mov    0x80110c70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 0c 11 80    	mov    %ebx,0x80110c70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 09 11 80    	cmp    $0x801109c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 c5 10 80       	push   $0x8010c520
801000e4:	e8 f7 45 00 00       	call   801046e0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 0c 11 80    	mov    0x80110c70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c 0c 11 80    	mov    0x80110c6c,%ebx
80100126:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 c5 10 80       	push   $0x8010c520
80100162:	e8 19 45 00 00       	call   80104680 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ae 42 00 00       	call   80104420 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 5f 21 00 00       	call   801022f0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 8e 86 10 80       	push   $0x8010868e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 fd 42 00 00       	call   801044c0 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 17 21 00 00       	jmp    801022f0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 9f 86 10 80       	push   $0x8010869f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 bc 42 00 00       	call   801044c0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 6c 42 00 00       	call   80104480 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010021b:	e8 c0 44 00 00       	call   801046e0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 0c 11 80       	mov    0x80110c70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c 0c 11 80 	movl   $0x80110c1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 0c 11 80       	mov    0x80110c70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 0c 11 80    	mov    %ebx,0x80110c70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 c5 10 80 	movl   $0x8010c520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 0f 44 00 00       	jmp    80104680 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 a6 86 10 80       	push   $0x801086a6
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 d7 15 00 00       	call   80101870 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 0f 11 80 	movl   $0x80110f20,(%esp)
801002a0:	e8 3b 44 00 00       	call   801046e0 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 0f 11 80       	mov    0x80110f00,%eax
801002b5:	3b 05 04 0f 11 80    	cmp    0x80110f04,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 0f 11 80       	push   $0x80110f20
801002c8:	68 00 0f 11 80       	push   $0x80110f00
801002cd:	e8 ae 3e 00 00       	call   80104180 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 0f 11 80       	mov    0x80110f00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 0f 11 80    	cmp    0x80110f04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 f9 36 00 00       	call   801039e0 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 0f 11 80       	push   $0x80110f20
801002f6:	e8 85 43 00 00       	call   80104680 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 8c 14 00 00       	call   80101790 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 0f 11 80    	mov    %edx,0x80110f00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 0e 11 80 	movsbl -0x7feef180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 0f 11 80       	push   $0x80110f20
8010034c:	e8 2f 43 00 00       	call   80104680 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 36 14 00 00       	call   80101790 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 0f 11 80       	mov    %eax,0x80110f00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 54 0f 11 80 00 	movl   $0x0,0x80110f54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 62 25 00 00       	call   80102900 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 ad 86 10 80       	push   $0x801086ad
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 0e 92 10 80 	movl   $0x8010920e,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 63 41 00 00       	call   80104530 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 c1 86 10 80       	push   $0x801086c1
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 0f 11 80 01 	movl   $0x1,0x80110f58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 41 5d 00 00       	call   80106160 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if(pos < 0 || pos > 25*80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100493:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 56 5c 00 00       	call   80106160 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 4a 5c 00 00       	call   80106160 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 3e 5c 00 00       	call   80106160 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 ea 42 00 00       	call   80104840 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 35 42 00 00       	call   801047a0 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 c5 86 10 80       	push   $0x801086c5
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 cc 12 00 00       	call   80101870 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 0f 11 80 	movl   $0x80110f20,(%esp)
801005ab:	e8 30 41 00 00       	call   801046e0 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 58 0f 11 80    	mov    0x80110f58,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli    
    for(;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 20 0f 11 80       	push   $0x80110f20
801005e4:	e8 97 40 00 00       	call   80104680 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 9e 11 00 00       	call   80101790 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 f0 86 10 80 	movzbl -0x7fef7910(%edx),%edx
  }while((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if(sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100662:	8b 15 58 0f 11 80    	mov    0x80110f58,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
    for(;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 54 0f 11 80       	mov    0x80110f54,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
    switch(c){
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
  if(locking)
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
}
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret    
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
      for(; *s; s++)
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
  if(panicked){
80100760:	8b 15 58 0f 11 80    	mov    0x80110f58,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli    
    for(;;)
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100787:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007a8:	8b 0d 58 0f 11 80    	mov    0x80110f58,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 58 0f 11 80       	mov    0x80110f58,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 20 0f 11 80       	push   $0x80110f20
801007e8:	e8 f3 3e 00 00       	call   801046e0 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 58 0f 11 80    	mov    0x80110f58,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 58 0f 11 80    	mov    0x80110f58,%edx
80100812:	85 d2                	test   %edx,%edx
80100814:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100817:	74 2e                	je     80100847 <cprintf+0x1a7>
80100819:	fa                   	cli    
    for(;;)
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli    
    for(;;)
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli    
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
        s = "(null)";
80100838:	bf d8 86 10 80       	mov    $0x801086d8,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 0f 11 80       	push   $0x80110f20
8010085b:	e8 20 3e 00 00       	call   80104680 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 df 86 10 80       	push   $0x801086df
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <consoleintr>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
  int c, doprocdump = 0;
80100885:	31 f6                	xor    %esi,%esi
{
80100887:	53                   	push   %ebx
80100888:	83 ec 18             	sub    $0x18,%esp
8010088b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010088e:	68 20 0f 11 80       	push   $0x80110f20
80100893:	e8 48 3e 00 00       	call   801046e0 <acquire>
  while((c = getc()) >= 0){
80100898:	83 c4 10             	add    $0x10,%esp
8010089b:	eb 1a                	jmp    801008b7 <consoleintr+0x37>
8010089d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008a0:	83 fb 08             	cmp    $0x8,%ebx
801008a3:	0f 84 d7 00 00 00    	je     80100980 <consoleintr+0x100>
801008a9:	83 fb 10             	cmp    $0x10,%ebx
801008ac:	0f 85 32 01 00 00    	jne    801009e4 <consoleintr+0x164>
801008b2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008b7:	ff d7                	call   *%edi
801008b9:	89 c3                	mov    %eax,%ebx
801008bb:	85 c0                	test   %eax,%eax
801008bd:	0f 88 05 01 00 00    	js     801009c8 <consoleintr+0x148>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 78                	je     80100940 <consoleintr+0xc0>
801008c8:	7e d6                	jle    801008a0 <consoleintr+0x20>
801008ca:	83 fb 7f             	cmp    $0x7f,%ebx
801008cd:	0f 84 ad 00 00 00    	je     80100980 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d3:	a1 08 0f 11 80       	mov    0x80110f08,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 00 0f 11 80    	sub    0x80110f00,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 58 0f 11 80    	mov    0x80110f58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 08 0f 11 80    	mov    %ecx,0x80110f08
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 80 0e 11 80    	mov    %bl,-0x7feef180(%eax)
  if(panicked){
80100906:	85 d2                	test   %edx,%edx
80100908:	0f 85 10 01 00 00    	jne    80100a1e <consoleintr+0x19e>
8010090e:	89 d8                	mov    %ebx,%eax
80100910:	e8 eb fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100915:	83 fb 0a             	cmp    $0xa,%ebx
80100918:	0f 84 14 01 00 00    	je     80100a32 <consoleintr+0x1b2>
8010091e:	83 fb 04             	cmp    $0x4,%ebx
80100921:	0f 84 0b 01 00 00    	je     80100a32 <consoleintr+0x1b2>
80100927:	a1 00 0f 11 80       	mov    0x80110f00,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 08 0f 11 80    	cmp    %eax,0x80110f08
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100940:	a1 08 0f 11 80       	mov    0x80110f08,%eax
80100945:	39 05 04 0f 11 80    	cmp    %eax,0x80110f04
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba 80 0e 11 80 0a 	cmpb   $0xa,-0x7feef180(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 58 0f 11 80    	mov    0x80110f58,%edx
        input.e--;
8010096c:	a3 08 0f 11 80       	mov    %eax,0x80110f08
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli    
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(input.e != input.w){
80100980:	a1 08 0f 11 80       	mov    0x80110f08,%eax
80100985:	3b 05 04 0f 11 80    	cmp    0x80110f04,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 08 0f 11 80       	mov    %eax,0x80110f08
  if(panicked){
80100999:	a1 58 0f 11 80       	mov    0x80110f58,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 08 0f 11 80       	mov    0x80110f08,%eax
801009b7:	3b 05 04 0f 11 80    	cmp    0x80110f04,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 20 0f 11 80       	push   $0x80110f20
801009d0:	e8 ab 3c 00 00       	call   80104680 <release>
  if(doprocdump) {
801009d5:	83 c4 10             	add    $0x10,%esp
801009d8:	85 f6                	test   %esi,%esi
801009da:	75 2b                	jne    80100a07 <consoleintr+0x187>
}
801009dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009df:	5b                   	pop    %ebx
801009e0:	5e                   	pop    %esi
801009e1:	5f                   	pop    %edi
801009e2:	5d                   	pop    %ebp
801009e3:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009e4:	85 db                	test   %ebx,%ebx
801009e6:	0f 84 cb fe ff ff    	je     801008b7 <consoleintr+0x37>
801009ec:	e9 e2 fe ff ff       	jmp    801008d3 <consoleintr+0x53>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f8:	b8 00 01 00 00       	mov    $0x100,%eax
801009fd:	e8 fe f9 ff ff       	call   80100400 <consputc.part.0>
80100a02:	e9 b0 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
}
80100a07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a0a:	5b                   	pop    %ebx
80100a0b:	5e                   	pop    %esi
80100a0c:	5f                   	pop    %edi
80100a0d:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a0e:	e9 0d 39 00 00       	jmp    80104320 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a13:	c6 80 80 0e 11 80 0a 	movb   $0xa,-0x7feef180(%eax)
  if(panicked){
80100a1a:	85 d2                	test   %edx,%edx
80100a1c:	74 0a                	je     80100a28 <consoleintr+0x1a8>
80100a1e:	fa                   	cli    
    for(;;)
80100a1f:	eb fe                	jmp    80100a1f <consoleintr+0x19f>
80100a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a28:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a2d:	e8 ce f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a32:	a1 08 0f 11 80       	mov    0x80110f08,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 04 0f 11 80       	mov    %eax,0x80110f04
          wakeup(&input.r);
80100a3f:	68 00 0f 11 80       	push   $0x80110f00
80100a44:	e8 f7 37 00 00       	call   80104240 <wakeup>
80100a49:	83 c4 10             	add    $0x10,%esp
80100a4c:	e9 66 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
80100a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 e8 86 10 80       	push   $0x801086e8
80100a6b:	68 20 0f 11 80       	push   $0x80110f20
80100a70:	e8 9b 3a 00 00       	call   80104510 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c 19 11 80 90 	movl   $0x80100590,0x8011190c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 19 11 80 80 	movl   $0x80100280,0x80111908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 0f 11 80 01 	movl   $0x1,0x80110f54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 f2 19 00 00       	call   80102490 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave  
80100aa2:	c3                   	ret    
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 1f 2f 00 00       	call   801039e0 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 a4 22 00 00       	call   80102d70 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 d9 15 00 00       	call   801020b0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 12 03 00 00    	je     80100df4 <exec+0x344>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 a3 0c 00 00       	call   80101790 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 a2 0f 00 00       	call   80101aa0 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	74 22                	je     80100b28 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	53                   	push   %ebx
80100b0a:	e8 11 0f 00 00       	call   80101a20 <iunlockput>
    end_op();
80100b0f:	e8 cc 22 00 00       	call   80102de0 <end_op>
80100b14:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b1f:	5b                   	pop    %ebx
80100b20:	5e                   	pop    %esi
80100b21:	5f                   	pop    %edi
80100b22:	5d                   	pop    %ebp
80100b23:	c3                   	ret    
80100b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b28:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b2f:	45 4c 46 
80100b32:	75 d2                	jne    80100b06 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b34:	e8 c7 68 00 00       	call   80107400 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 bc 02 00 00    	je     80100e13 <exec+0x363>
  sz = 0;
80100b57:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b5e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b61:	31 ff                	xor    %edi,%edi
80100b63:	e9 98 00 00 00       	jmp    80100c00 <exec+0x150>
80100b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b6f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b70:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b77:	75 76                	jne    80100bef <exec+0x13f>
    if(ph.memsz < ph.filesz)
80100b79:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b7f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b85:	0f 82 91 00 00 00    	jb     80100c1c <exec+0x16c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b8b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b91:	0f 82 85 00 00 00    	jb     80100c1c <exec+0x16c>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b97:	83 ec 04             	sub    $0x4,%esp
80100b9a:	50                   	push   %eax
80100b9b:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100ba1:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ba7:	e8 04 66 00 00       	call   801071b0 <allocuvm>
80100bac:	83 c4 10             	add    $0x10,%esp
80100baf:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bb5:	85 c0                	test   %eax,%eax
80100bb7:	74 63                	je     80100c1c <exec+0x16c>
    if(ph.vaddr % PGSIZE != 0)
80100bb9:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bbf:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bc4:	75 56                	jne    80100c1c <exec+0x16c>
	if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz, ph.flags) < 0)
80100bc6:	83 ec 08             	sub    $0x8,%esp
80100bc9:	ff b5 1c ff ff ff    	push   -0xe4(%ebp)
80100bcf:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bd5:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bdb:	53                   	push   %ebx
80100bdc:	50                   	push   %eax
80100bdd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100be3:	e8 c8 64 00 00       	call   801070b0 <loaduvm>
80100be8:	83 c4 20             	add    $0x20,%esp
80100beb:	85 c0                	test   %eax,%eax
80100bed:	78 2d                	js     80100c1c <exec+0x16c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bef:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bf6:	83 c7 01             	add    $0x1,%edi
80100bf9:	83 c6 20             	add    $0x20,%esi
80100bfc:	39 f8                	cmp    %edi,%eax
80100bfe:	7e 38                	jle    80100c38 <exec+0x188>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c00:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100c06:	6a 20                	push   $0x20
80100c08:	56                   	push   %esi
80100c09:	50                   	push   %eax
80100c0a:	53                   	push   %ebx
80100c0b:	e8 90 0e 00 00       	call   80101aa0 <readi>
80100c10:	83 c4 10             	add    $0x10,%esp
80100c13:	83 f8 20             	cmp    $0x20,%eax
80100c16:	0f 84 54 ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c1c:	83 ec 0c             	sub    $0xc,%esp
80100c1f:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c25:	e8 16 67 00 00       	call   80107340 <freevm>
  if(ip){
80100c2a:	83 c4 10             	add    $0x10,%esp
80100c2d:	e9 d4 fe ff ff       	jmp    80100b06 <exec+0x56>
80100c32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  sz = PGROUNDUP(sz);
80100c38:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c3e:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c44:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c4a:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c50:	83 ec 0c             	sub    $0xc,%esp
80100c53:	53                   	push   %ebx
80100c54:	e8 c7 0d 00 00       	call   80101a20 <iunlockput>
  end_op();
80100c59:	e8 82 21 00 00       	call   80102de0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c5e:	83 c4 0c             	add    $0xc,%esp
80100c61:	56                   	push   %esi
80100c62:	57                   	push   %edi
80100c63:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c69:	57                   	push   %edi
80100c6a:	e8 41 65 00 00       	call   801071b0 <allocuvm>
80100c6f:	83 c4 10             	add    $0x10,%esp
80100c72:	89 c6                	mov    %eax,%esi
80100c74:	85 c0                	test   %eax,%eax
80100c76:	0f 84 94 00 00 00    	je     80100d10 <exec+0x260>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7c:	83 ec 08             	sub    $0x8,%esp
80100c7f:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c85:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c87:	50                   	push   %eax
80100c88:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c89:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c8b:	e8 10 68 00 00       	call   801074a0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c90:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c93:	83 c4 10             	add    $0x10,%esp
80100c96:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c9c:	8b 00                	mov    (%eax),%eax
80100c9e:	85 c0                	test   %eax,%eax
80100ca0:	0f 84 8b 00 00 00    	je     80100d31 <exec+0x281>
80100ca6:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100cac:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100cb2:	eb 23                	jmp    80100cd7 <exec+0x227>
80100cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cb8:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100cbb:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100cc2:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cc5:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100ccb:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cce:	85 c0                	test   %eax,%eax
80100cd0:	74 59                	je     80100d2b <exec+0x27b>
    if(argc >= MAXARG)
80100cd2:	83 ff 20             	cmp    $0x20,%edi
80100cd5:	74 39                	je     80100d10 <exec+0x260>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cd7:	83 ec 0c             	sub    $0xc,%esp
80100cda:	50                   	push   %eax
80100cdb:	e8 c0 3c 00 00       	call   801049a0 <strlen>
80100ce0:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce2:	58                   	pop    %eax
80100ce3:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ce6:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce9:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cec:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cef:	e8 ac 3c 00 00       	call   801049a0 <strlen>
80100cf4:	83 c0 01             	add    $0x1,%eax
80100cf7:	50                   	push   %eax
80100cf8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cfb:	ff 34 b8             	push   (%eax,%edi,4)
80100cfe:	53                   	push   %ebx
80100cff:	56                   	push   %esi
80100d00:	e8 9b 69 00 00       	call   801076a0 <copyout>
80100d05:	83 c4 20             	add    $0x20,%esp
80100d08:	85 c0                	test   %eax,%eax
80100d0a:	79 ac                	jns    80100cb8 <exec+0x208>
80100d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d10:	83 ec 0c             	sub    $0xc,%esp
80100d13:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d19:	e8 22 66 00 00       	call   80107340 <freevm>
80100d1e:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d26:	e9 f1 fd ff ff       	jmp    80100b1c <exec+0x6c>
80100d2b:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d31:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d38:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d3a:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d41:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d45:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d47:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d4a:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d50:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d52:	50                   	push   %eax
80100d53:	52                   	push   %edx
80100d54:	53                   	push   %ebx
80100d55:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d5b:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d62:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d65:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d6b:	e8 30 69 00 00       	call   801076a0 <copyout>
80100d70:	83 c4 10             	add    $0x10,%esp
80100d73:	85 c0                	test   %eax,%eax
80100d75:	78 99                	js     80100d10 <exec+0x260>
  for(last=s=path; *s; s++)
80100d77:	8b 45 08             	mov    0x8(%ebp),%eax
80100d7a:	8b 55 08             	mov    0x8(%ebp),%edx
80100d7d:	0f b6 00             	movzbl (%eax),%eax
80100d80:	84 c0                	test   %al,%al
80100d82:	74 1b                	je     80100d9f <exec+0x2ef>
80100d84:	89 d1                	mov    %edx,%ecx
80100d86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100d8d:	8d 76 00             	lea    0x0(%esi),%esi
      last = s+1;
80100d90:	83 c1 01             	add    $0x1,%ecx
80100d93:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d95:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d98:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d9b:	84 c0                	test   %al,%al
80100d9d:	75 f1                	jne    80100d90 <exec+0x2e0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d9f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100da5:	83 ec 04             	sub    $0x4,%esp
80100da8:	6a 10                	push   $0x10
80100daa:	89 f8                	mov    %edi,%eax
80100dac:	52                   	push   %edx
80100dad:	83 c0 6c             	add    $0x6c,%eax
80100db0:	50                   	push   %eax
80100db1:	e8 aa 3b 00 00       	call   80104960 <safestrcpy>
  curproc->pgdir = pgdir;
80100db6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dbc:	89 f8                	mov    %edi,%eax
80100dbe:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100dc1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100dc3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100dc6:	89 c1                	mov    %eax,%ecx
80100dc8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dce:	8b 40 18             	mov    0x18(%eax),%eax
80100dd1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dd4:	8b 41 18             	mov    0x18(%ecx),%eax
80100dd7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dda:	89 0c 24             	mov    %ecx,(%esp)
80100ddd:	e8 1e 61 00 00       	call   80106f00 <switchuvm>
  freevm(oldpgdir);
80100de2:	89 3c 24             	mov    %edi,(%esp)
80100de5:	e8 56 65 00 00       	call   80107340 <freevm>
  return 0;
80100dea:	83 c4 10             	add    $0x10,%esp
80100ded:	31 c0                	xor    %eax,%eax
80100def:	e9 28 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100df4:	e8 e7 1f 00 00       	call   80102de0 <end_op>
    cprintf("exec: fail\n");
80100df9:	83 ec 0c             	sub    $0xc,%esp
80100dfc:	68 01 87 10 80       	push   $0x80108701
80100e01:	e8 9a f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100e06:	83 c4 10             	add    $0x10,%esp
80100e09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e0e:	e9 09 fd ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e13:	be 00 20 00 00       	mov    $0x2000,%esi
80100e18:	31 ff                	xor    %edi,%edi
80100e1a:	e9 31 fe ff ff       	jmp    80100c50 <exec+0x1a0>
80100e1f:	90                   	nop

80100e20 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e20:	55                   	push   %ebp
80100e21:	89 e5                	mov    %esp,%ebp
80100e23:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e26:	68 0d 87 10 80       	push   $0x8010870d
80100e2b:	68 60 0f 11 80       	push   $0x80110f60
80100e30:	e8 db 36 00 00       	call   80104510 <initlock>
}
80100e35:	83 c4 10             	add    $0x10,%esp
80100e38:	c9                   	leave  
80100e39:	c3                   	ret    
80100e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e40 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e44:	bb 94 0f 11 80       	mov    $0x80110f94,%ebx
{
80100e49:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e4c:	68 60 0f 11 80       	push   $0x80110f60
80100e51:	e8 8a 38 00 00       	call   801046e0 <acquire>
80100e56:	83 c4 10             	add    $0x10,%esp
80100e59:	eb 10                	jmp    80100e6b <filealloc+0x2b>
80100e5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e5f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e60:	83 c3 18             	add    $0x18,%ebx
80100e63:	81 fb f4 18 11 80    	cmp    $0x801118f4,%ebx
80100e69:	74 25                	je     80100e90 <filealloc+0x50>
    if(f->ref == 0){
80100e6b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e6e:	85 c0                	test   %eax,%eax
80100e70:	75 ee                	jne    80100e60 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e72:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e75:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e7c:	68 60 0f 11 80       	push   $0x80110f60
80100e81:	e8 fa 37 00 00       	call   80104680 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e86:	89 d8                	mov    %ebx,%eax
      return f;
80100e88:	83 c4 10             	add    $0x10,%esp
}
80100e8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e8e:	c9                   	leave  
80100e8f:	c3                   	ret    
  release(&ftable.lock);
80100e90:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e93:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e95:	68 60 0f 11 80       	push   $0x80110f60
80100e9a:	e8 e1 37 00 00       	call   80104680 <release>
}
80100e9f:	89 d8                	mov    %ebx,%eax
  return 0;
80100ea1:	83 c4 10             	add    $0x10,%esp
}
80100ea4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ea7:	c9                   	leave  
80100ea8:	c3                   	ret    
80100ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100eb0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100eb0:	55                   	push   %ebp
80100eb1:	89 e5                	mov    %esp,%ebp
80100eb3:	53                   	push   %ebx
80100eb4:	83 ec 10             	sub    $0x10,%esp
80100eb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eba:	68 60 0f 11 80       	push   $0x80110f60
80100ebf:	e8 1c 38 00 00       	call   801046e0 <acquire>
  if(f->ref < 1)
80100ec4:	8b 43 04             	mov    0x4(%ebx),%eax
80100ec7:	83 c4 10             	add    $0x10,%esp
80100eca:	85 c0                	test   %eax,%eax
80100ecc:	7e 1a                	jle    80100ee8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ece:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ed1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ed4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ed7:	68 60 0f 11 80       	push   $0x80110f60
80100edc:	e8 9f 37 00 00       	call   80104680 <release>
  return f;
}
80100ee1:	89 d8                	mov    %ebx,%eax
80100ee3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ee6:	c9                   	leave  
80100ee7:	c3                   	ret    
    panic("filedup");
80100ee8:	83 ec 0c             	sub    $0xc,%esp
80100eeb:	68 14 87 10 80       	push   $0x80108714
80100ef0:	e8 8b f4 ff ff       	call   80100380 <panic>
80100ef5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f00 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	57                   	push   %edi
80100f04:	56                   	push   %esi
80100f05:	53                   	push   %ebx
80100f06:	83 ec 28             	sub    $0x28,%esp
80100f09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f0c:	68 60 0f 11 80       	push   $0x80110f60
80100f11:	e8 ca 37 00 00       	call   801046e0 <acquire>
  if(f->ref < 1)
80100f16:	8b 53 04             	mov    0x4(%ebx),%edx
80100f19:	83 c4 10             	add    $0x10,%esp
80100f1c:	85 d2                	test   %edx,%edx
80100f1e:	0f 8e a5 00 00 00    	jle    80100fc9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f24:	83 ea 01             	sub    $0x1,%edx
80100f27:	89 53 04             	mov    %edx,0x4(%ebx)
80100f2a:	75 44                	jne    80100f70 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f2c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f30:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f33:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f35:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f3b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f3e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f41:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f44:	68 60 0f 11 80       	push   $0x80110f60
  ff = *f;
80100f49:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f4c:	e8 2f 37 00 00       	call   80104680 <release>

  if(ff.type == FD_PIPE)
80100f51:	83 c4 10             	add    $0x10,%esp
80100f54:	83 ff 01             	cmp    $0x1,%edi
80100f57:	74 57                	je     80100fb0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f59:	83 ff 02             	cmp    $0x2,%edi
80100f5c:	74 2a                	je     80100f88 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f61:	5b                   	pop    %ebx
80100f62:	5e                   	pop    %esi
80100f63:	5f                   	pop    %edi
80100f64:	5d                   	pop    %ebp
80100f65:	c3                   	ret    
80100f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f6d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f70:	c7 45 08 60 0f 11 80 	movl   $0x80110f60,0x8(%ebp)
}
80100f77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f7a:	5b                   	pop    %ebx
80100f7b:	5e                   	pop    %esi
80100f7c:	5f                   	pop    %edi
80100f7d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f7e:	e9 fd 36 00 00       	jmp    80104680 <release>
80100f83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f87:	90                   	nop
    begin_op();
80100f88:	e8 e3 1d 00 00       	call   80102d70 <begin_op>
    iput(ff.ip);
80100f8d:	83 ec 0c             	sub    $0xc,%esp
80100f90:	ff 75 e0             	push   -0x20(%ebp)
80100f93:	e8 28 09 00 00       	call   801018c0 <iput>
    end_op();
80100f98:	83 c4 10             	add    $0x10,%esp
}
80100f9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f9e:	5b                   	pop    %ebx
80100f9f:	5e                   	pop    %esi
80100fa0:	5f                   	pop    %edi
80100fa1:	5d                   	pop    %ebp
    end_op();
80100fa2:	e9 39 1e 00 00       	jmp    80102de0 <end_op>
80100fa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fae:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fb0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fb4:	83 ec 08             	sub    $0x8,%esp
80100fb7:	53                   	push   %ebx
80100fb8:	56                   	push   %esi
80100fb9:	e8 82 25 00 00       	call   80103540 <pipeclose>
80100fbe:	83 c4 10             	add    $0x10,%esp
}
80100fc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc4:	5b                   	pop    %ebx
80100fc5:	5e                   	pop    %esi
80100fc6:	5f                   	pop    %edi
80100fc7:	5d                   	pop    %ebp
80100fc8:	c3                   	ret    
    panic("fileclose");
80100fc9:	83 ec 0c             	sub    $0xc,%esp
80100fcc:	68 1c 87 10 80       	push   $0x8010871c
80100fd1:	e8 aa f3 ff ff       	call   80100380 <panic>
80100fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fdd:	8d 76 00             	lea    0x0(%esi),%esi

80100fe0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	53                   	push   %ebx
80100fe4:	83 ec 04             	sub    $0x4,%esp
80100fe7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fea:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fed:	75 31                	jne    80101020 <filestat+0x40>
    ilock(f->ip);
80100fef:	83 ec 0c             	sub    $0xc,%esp
80100ff2:	ff 73 10             	push   0x10(%ebx)
80100ff5:	e8 96 07 00 00       	call   80101790 <ilock>
    stati(f->ip, st);
80100ffa:	58                   	pop    %eax
80100ffb:	5a                   	pop    %edx
80100ffc:	ff 75 0c             	push   0xc(%ebp)
80100fff:	ff 73 10             	push   0x10(%ebx)
80101002:	e8 69 0a 00 00       	call   80101a70 <stati>
    iunlock(f->ip);
80101007:	59                   	pop    %ecx
80101008:	ff 73 10             	push   0x10(%ebx)
8010100b:	e8 60 08 00 00       	call   80101870 <iunlock>
    return 0;
  }
  return -1;
}
80101010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101013:	83 c4 10             	add    $0x10,%esp
80101016:	31 c0                	xor    %eax,%eax
}
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101020:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101023:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101028:	c9                   	leave  
80101029:	c3                   	ret    
8010102a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101030 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101030:	55                   	push   %ebp
80101031:	89 e5                	mov    %esp,%ebp
80101033:	57                   	push   %edi
80101034:	56                   	push   %esi
80101035:	53                   	push   %ebx
80101036:	83 ec 0c             	sub    $0xc,%esp
80101039:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010103c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010103f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101042:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101046:	74 60                	je     801010a8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101048:	8b 03                	mov    (%ebx),%eax
8010104a:	83 f8 01             	cmp    $0x1,%eax
8010104d:	74 41                	je     80101090 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010104f:	83 f8 02             	cmp    $0x2,%eax
80101052:	75 5b                	jne    801010af <fileread+0x7f>
    ilock(f->ip);
80101054:	83 ec 0c             	sub    $0xc,%esp
80101057:	ff 73 10             	push   0x10(%ebx)
8010105a:	e8 31 07 00 00       	call   80101790 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010105f:	57                   	push   %edi
80101060:	ff 73 14             	push   0x14(%ebx)
80101063:	56                   	push   %esi
80101064:	ff 73 10             	push   0x10(%ebx)
80101067:	e8 34 0a 00 00       	call   80101aa0 <readi>
8010106c:	83 c4 20             	add    $0x20,%esp
8010106f:	89 c6                	mov    %eax,%esi
80101071:	85 c0                	test   %eax,%eax
80101073:	7e 03                	jle    80101078 <fileread+0x48>
      f->off += r;
80101075:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101078:	83 ec 0c             	sub    $0xc,%esp
8010107b:	ff 73 10             	push   0x10(%ebx)
8010107e:	e8 ed 07 00 00       	call   80101870 <iunlock>
    return r;
80101083:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101089:	89 f0                	mov    %esi,%eax
8010108b:	5b                   	pop    %ebx
8010108c:	5e                   	pop    %esi
8010108d:	5f                   	pop    %edi
8010108e:	5d                   	pop    %ebp
8010108f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101090:	8b 43 0c             	mov    0xc(%ebx),%eax
80101093:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101096:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101099:	5b                   	pop    %ebx
8010109a:	5e                   	pop    %esi
8010109b:	5f                   	pop    %edi
8010109c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010109d:	e9 3e 26 00 00       	jmp    801036e0 <piperead>
801010a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010a8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010ad:	eb d7                	jmp    80101086 <fileread+0x56>
  panic("fileread");
801010af:	83 ec 0c             	sub    $0xc,%esp
801010b2:	68 26 87 10 80       	push   $0x80108726
801010b7:	e8 c4 f2 ff ff       	call   80100380 <panic>
801010bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010c0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010c0:	55                   	push   %ebp
801010c1:	89 e5                	mov    %esp,%ebp
801010c3:	57                   	push   %edi
801010c4:	56                   	push   %esi
801010c5:	53                   	push   %ebx
801010c6:	83 ec 1c             	sub    $0x1c,%esp
801010c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010cf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010d2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010d5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010dc:	0f 84 bd 00 00 00    	je     8010119f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801010e2:	8b 03                	mov    (%ebx),%eax
801010e4:	83 f8 01             	cmp    $0x1,%eax
801010e7:	0f 84 bf 00 00 00    	je     801011ac <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010ed:	83 f8 02             	cmp    $0x2,%eax
801010f0:	0f 85 c8 00 00 00    	jne    801011be <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010f9:	31 f6                	xor    %esi,%esi
    while(i < n){
801010fb:	85 c0                	test   %eax,%eax
801010fd:	7f 30                	jg     8010112f <filewrite+0x6f>
801010ff:	e9 94 00 00 00       	jmp    80101198 <filewrite+0xd8>
80101104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101108:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010110b:	83 ec 0c             	sub    $0xc,%esp
8010110e:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101111:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101114:	e8 57 07 00 00       	call   80101870 <iunlock>
      end_op();
80101119:	e8 c2 1c 00 00       	call   80102de0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010111e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101121:	83 c4 10             	add    $0x10,%esp
80101124:	39 c7                	cmp    %eax,%edi
80101126:	75 5c                	jne    80101184 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101128:	01 fe                	add    %edi,%esi
    while(i < n){
8010112a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010112d:	7e 69                	jle    80101198 <filewrite+0xd8>
      int n1 = n - i;
8010112f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101132:	b8 00 06 00 00       	mov    $0x600,%eax
80101137:	29 f7                	sub    %esi,%edi
80101139:	39 c7                	cmp    %eax,%edi
8010113b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010113e:	e8 2d 1c 00 00       	call   80102d70 <begin_op>
      ilock(f->ip);
80101143:	83 ec 0c             	sub    $0xc,%esp
80101146:	ff 73 10             	push   0x10(%ebx)
80101149:	e8 42 06 00 00       	call   80101790 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010114e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101151:	57                   	push   %edi
80101152:	ff 73 14             	push   0x14(%ebx)
80101155:	01 f0                	add    %esi,%eax
80101157:	50                   	push   %eax
80101158:	ff 73 10             	push   0x10(%ebx)
8010115b:	e8 40 0a 00 00       	call   80101ba0 <writei>
80101160:	83 c4 20             	add    $0x20,%esp
80101163:	85 c0                	test   %eax,%eax
80101165:	7f a1                	jg     80101108 <filewrite+0x48>
      iunlock(f->ip);
80101167:	83 ec 0c             	sub    $0xc,%esp
8010116a:	ff 73 10             	push   0x10(%ebx)
8010116d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101170:	e8 fb 06 00 00       	call   80101870 <iunlock>
      end_op();
80101175:	e8 66 1c 00 00       	call   80102de0 <end_op>
      if(r < 0)
8010117a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010117d:	83 c4 10             	add    $0x10,%esp
80101180:	85 c0                	test   %eax,%eax
80101182:	75 1b                	jne    8010119f <filewrite+0xdf>
        panic("short filewrite");
80101184:	83 ec 0c             	sub    $0xc,%esp
80101187:	68 2f 87 10 80       	push   $0x8010872f
8010118c:	e8 ef f1 ff ff       	call   80100380 <panic>
80101191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101198:	89 f0                	mov    %esi,%eax
8010119a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010119d:	74 05                	je     801011a4 <filewrite+0xe4>
8010119f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801011a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a7:	5b                   	pop    %ebx
801011a8:	5e                   	pop    %esi
801011a9:	5f                   	pop    %edi
801011aa:	5d                   	pop    %ebp
801011ab:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801011ac:	8b 43 0c             	mov    0xc(%ebx),%eax
801011af:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011b5:	5b                   	pop    %ebx
801011b6:	5e                   	pop    %esi
801011b7:	5f                   	pop    %edi
801011b8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011b9:	e9 22 24 00 00       	jmp    801035e0 <pipewrite>
  panic("filewrite");
801011be:	83 ec 0c             	sub    $0xc,%esp
801011c1:	68 35 87 10 80       	push   $0x80108735
801011c6:	e8 b5 f1 ff ff       	call   80100380 <panic>
801011cb:	66 90                	xchg   %ax,%ax
801011cd:	66 90                	xchg   %ax,%ax
801011cf:	90                   	nop

801011d0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011d0:	55                   	push   %ebp
801011d1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011d3:	89 d0                	mov    %edx,%eax
801011d5:	c1 e8 0c             	shr    $0xc,%eax
801011d8:	03 05 cc 35 11 80    	add    0x801135cc,%eax
{
801011de:	89 e5                	mov    %esp,%ebp
801011e0:	56                   	push   %esi
801011e1:	53                   	push   %ebx
801011e2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011e4:	83 ec 08             	sub    $0x8,%esp
801011e7:	50                   	push   %eax
801011e8:	51                   	push   %ecx
801011e9:	e8 e2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011ee:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011f0:	c1 fb 03             	sar    $0x3,%ebx
801011f3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801011f6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801011f8:	83 e1 07             	and    $0x7,%ecx
801011fb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101200:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101206:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101208:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010120d:	85 c1                	test   %eax,%ecx
8010120f:	74 23                	je     80101234 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101211:	f7 d0                	not    %eax
  log_write(bp);
80101213:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101216:	21 c8                	and    %ecx,%eax
80101218:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010121c:	56                   	push   %esi
8010121d:	e8 2e 1d 00 00       	call   80102f50 <log_write>
  brelse(bp);
80101222:	89 34 24             	mov    %esi,(%esp)
80101225:	e8 c6 ef ff ff       	call   801001f0 <brelse>
}
8010122a:	83 c4 10             	add    $0x10,%esp
8010122d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101230:	5b                   	pop    %ebx
80101231:	5e                   	pop    %esi
80101232:	5d                   	pop    %ebp
80101233:	c3                   	ret    
    panic("freeing free block");
80101234:	83 ec 0c             	sub    $0xc,%esp
80101237:	68 3f 87 10 80       	push   $0x8010873f
8010123c:	e8 3f f1 ff ff       	call   80100380 <panic>
80101241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101248:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010124f:	90                   	nop

80101250 <balloc>:
{
80101250:	55                   	push   %ebp
80101251:	89 e5                	mov    %esp,%ebp
80101253:	57                   	push   %edi
80101254:	56                   	push   %esi
80101255:	53                   	push   %ebx
80101256:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101259:	8b 0d b4 35 11 80    	mov    0x801135b4,%ecx
{
8010125f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101262:	85 c9                	test   %ecx,%ecx
80101264:	0f 84 87 00 00 00    	je     801012f1 <balloc+0xa1>
8010126a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101271:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101274:	83 ec 08             	sub    $0x8,%esp
80101277:	89 f0                	mov    %esi,%eax
80101279:	c1 f8 0c             	sar    $0xc,%eax
8010127c:	03 05 cc 35 11 80    	add    0x801135cc,%eax
80101282:	50                   	push   %eax
80101283:	ff 75 d8             	push   -0x28(%ebp)
80101286:	e8 45 ee ff ff       	call   801000d0 <bread>
8010128b:	83 c4 10             	add    $0x10,%esp
8010128e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101291:	a1 b4 35 11 80       	mov    0x801135b4,%eax
80101296:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101299:	31 c0                	xor    %eax,%eax
8010129b:	eb 2f                	jmp    801012cc <balloc+0x7c>
8010129d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801012a0:	89 c1                	mov    %eax,%ecx
801012a2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801012aa:	83 e1 07             	and    $0x7,%ecx
801012ad:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012af:	89 c1                	mov    %eax,%ecx
801012b1:	c1 f9 03             	sar    $0x3,%ecx
801012b4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012b9:	89 fa                	mov    %edi,%edx
801012bb:	85 df                	test   %ebx,%edi
801012bd:	74 41                	je     80101300 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012bf:	83 c0 01             	add    $0x1,%eax
801012c2:	83 c6 01             	add    $0x1,%esi
801012c5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ca:	74 05                	je     801012d1 <balloc+0x81>
801012cc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012cf:	77 cf                	ja     801012a0 <balloc+0x50>
    brelse(bp);
801012d1:	83 ec 0c             	sub    $0xc,%esp
801012d4:	ff 75 e4             	push   -0x1c(%ebp)
801012d7:	e8 14 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012dc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012e3:	83 c4 10             	add    $0x10,%esp
801012e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012e9:	39 05 b4 35 11 80    	cmp    %eax,0x801135b4
801012ef:	77 80                	ja     80101271 <balloc+0x21>
  panic("balloc: out of blocks");
801012f1:	83 ec 0c             	sub    $0xc,%esp
801012f4:	68 52 87 10 80       	push   $0x80108752
801012f9:	e8 82 f0 ff ff       	call   80100380 <panic>
801012fe:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101300:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101303:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101306:	09 da                	or     %ebx,%edx
80101308:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010130c:	57                   	push   %edi
8010130d:	e8 3e 1c 00 00       	call   80102f50 <log_write>
        brelse(bp);
80101312:	89 3c 24             	mov    %edi,(%esp)
80101315:	e8 d6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010131a:	58                   	pop    %eax
8010131b:	5a                   	pop    %edx
8010131c:	56                   	push   %esi
8010131d:	ff 75 d8             	push   -0x28(%ebp)
80101320:	e8 ab ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101325:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101328:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010132a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010132d:	68 00 02 00 00       	push   $0x200
80101332:	6a 00                	push   $0x0
80101334:	50                   	push   %eax
80101335:	e8 66 34 00 00       	call   801047a0 <memset>
  log_write(bp);
8010133a:	89 1c 24             	mov    %ebx,(%esp)
8010133d:	e8 0e 1c 00 00       	call   80102f50 <log_write>
  brelse(bp);
80101342:	89 1c 24             	mov    %ebx,(%esp)
80101345:	e8 a6 ee ff ff       	call   801001f0 <brelse>
}
8010134a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010134d:	89 f0                	mov    %esi,%eax
8010134f:	5b                   	pop    %ebx
80101350:	5e                   	pop    %esi
80101351:	5f                   	pop    %edi
80101352:	5d                   	pop    %ebp
80101353:	c3                   	ret    
80101354:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010135b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010135f:	90                   	nop

80101360 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	89 c7                	mov    %eax,%edi
80101366:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101367:	31 f6                	xor    %esi,%esi
{
80101369:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136a:	bb 94 19 11 80       	mov    $0x80111994,%ebx
{
8010136f:	83 ec 28             	sub    $0x28,%esp
80101372:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101375:	68 60 19 11 80       	push   $0x80111960
8010137a:	e8 61 33 00 00       	call   801046e0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010137f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101382:	83 c4 10             	add    $0x10,%esp
80101385:	eb 1b                	jmp    801013a2 <iget+0x42>
80101387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010138e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101390:	39 3b                	cmp    %edi,(%ebx)
80101392:	74 6c                	je     80101400 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101394:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010139a:	81 fb b4 35 11 80    	cmp    $0x801135b4,%ebx
801013a0:	73 26                	jae    801013c8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013a2:	8b 43 08             	mov    0x8(%ebx),%eax
801013a5:	85 c0                	test   %eax,%eax
801013a7:	7f e7                	jg     80101390 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801013a9:	85 f6                	test   %esi,%esi
801013ab:	75 e7                	jne    80101394 <iget+0x34>
801013ad:	85 c0                	test   %eax,%eax
801013af:	75 76                	jne    80101427 <iget+0xc7>
801013b1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013b3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013b9:	81 fb b4 35 11 80    	cmp    $0x801135b4,%ebx
801013bf:	72 e1                	jb     801013a2 <iget+0x42>
801013c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013c8:	85 f6                	test   %esi,%esi
801013ca:	74 79                	je     80101445 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013cc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013cf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013d1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013d4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013db:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013e2:	68 60 19 11 80       	push   $0x80111960
801013e7:	e8 94 32 00 00       	call   80104680 <release>

  return ip;
801013ec:	83 c4 10             	add    $0x10,%esp
}
801013ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013f2:	89 f0                	mov    %esi,%eax
801013f4:	5b                   	pop    %ebx
801013f5:	5e                   	pop    %esi
801013f6:	5f                   	pop    %edi
801013f7:	5d                   	pop    %ebp
801013f8:	c3                   	ret    
801013f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101400:	39 53 04             	cmp    %edx,0x4(%ebx)
80101403:	75 8f                	jne    80101394 <iget+0x34>
      release(&icache.lock);
80101405:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101408:	83 c0 01             	add    $0x1,%eax
      return ip;
8010140b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010140d:	68 60 19 11 80       	push   $0x80111960
      ip->ref++;
80101412:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101415:	e8 66 32 00 00       	call   80104680 <release>
      return ip;
8010141a:	83 c4 10             	add    $0x10,%esp
}
8010141d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101420:	89 f0                	mov    %esi,%eax
80101422:	5b                   	pop    %ebx
80101423:	5e                   	pop    %esi
80101424:	5f                   	pop    %edi
80101425:	5d                   	pop    %ebp
80101426:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101427:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010142d:	81 fb b4 35 11 80    	cmp    $0x801135b4,%ebx
80101433:	73 10                	jae    80101445 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101435:	8b 43 08             	mov    0x8(%ebx),%eax
80101438:	85 c0                	test   %eax,%eax
8010143a:	0f 8f 50 ff ff ff    	jg     80101390 <iget+0x30>
80101440:	e9 68 ff ff ff       	jmp    801013ad <iget+0x4d>
    panic("iget: no inodes");
80101445:	83 ec 0c             	sub    $0xc,%esp
80101448:	68 68 87 10 80       	push   $0x80108768
8010144d:	e8 2e ef ff ff       	call   80100380 <panic>
80101452:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101460 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101460:	55                   	push   %ebp
80101461:	89 e5                	mov    %esp,%ebp
80101463:	57                   	push   %edi
80101464:	56                   	push   %esi
80101465:	89 c6                	mov    %eax,%esi
80101467:	53                   	push   %ebx
80101468:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010146b:	83 fa 0b             	cmp    $0xb,%edx
8010146e:	0f 86 8c 00 00 00    	jbe    80101500 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101474:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101477:	83 fb 7f             	cmp    $0x7f,%ebx
8010147a:	0f 87 a2 00 00 00    	ja     80101522 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101480:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101486:	85 c0                	test   %eax,%eax
80101488:	74 5e                	je     801014e8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010148a:	83 ec 08             	sub    $0x8,%esp
8010148d:	50                   	push   %eax
8010148e:	ff 36                	push   (%esi)
80101490:	e8 3b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101495:	83 c4 10             	add    $0x10,%esp
80101498:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010149c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010149e:	8b 3b                	mov    (%ebx),%edi
801014a0:	85 ff                	test   %edi,%edi
801014a2:	74 1c                	je     801014c0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801014a4:	83 ec 0c             	sub    $0xc,%esp
801014a7:	52                   	push   %edx
801014a8:	e8 43 ed ff ff       	call   801001f0 <brelse>
801014ad:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014b3:	89 f8                	mov    %edi,%eax
801014b5:	5b                   	pop    %ebx
801014b6:	5e                   	pop    %esi
801014b7:	5f                   	pop    %edi
801014b8:	5d                   	pop    %ebp
801014b9:	c3                   	ret    
801014ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014c3:	8b 06                	mov    (%esi),%eax
801014c5:	e8 86 fd ff ff       	call   80101250 <balloc>
      log_write(bp);
801014ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014cd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014d0:	89 03                	mov    %eax,(%ebx)
801014d2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014d4:	52                   	push   %edx
801014d5:	e8 76 1a 00 00       	call   80102f50 <log_write>
801014da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014dd:	83 c4 10             	add    $0x10,%esp
801014e0:	eb c2                	jmp    801014a4 <bmap+0x44>
801014e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014e8:	8b 06                	mov    (%esi),%eax
801014ea:	e8 61 fd ff ff       	call   80101250 <balloc>
801014ef:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014f5:	eb 93                	jmp    8010148a <bmap+0x2a>
801014f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014fe:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
80101500:	8d 5a 14             	lea    0x14(%edx),%ebx
80101503:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101507:	85 ff                	test   %edi,%edi
80101509:	75 a5                	jne    801014b0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010150b:	8b 00                	mov    (%eax),%eax
8010150d:	e8 3e fd ff ff       	call   80101250 <balloc>
80101512:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101516:	89 c7                	mov    %eax,%edi
}
80101518:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010151b:	5b                   	pop    %ebx
8010151c:	89 f8                	mov    %edi,%eax
8010151e:	5e                   	pop    %esi
8010151f:	5f                   	pop    %edi
80101520:	5d                   	pop    %ebp
80101521:	c3                   	ret    
  panic("bmap: out of range");
80101522:	83 ec 0c             	sub    $0xc,%esp
80101525:	68 78 87 10 80       	push   $0x80108778
8010152a:	e8 51 ee ff ff       	call   80100380 <panic>
8010152f:	90                   	nop

80101530 <readsb>:
{
80101530:	55                   	push   %ebp
80101531:	89 e5                	mov    %esp,%ebp
80101533:	56                   	push   %esi
80101534:	53                   	push   %ebx
80101535:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101538:	83 ec 08             	sub    $0x8,%esp
8010153b:	6a 01                	push   $0x1
8010153d:	ff 75 08             	push   0x8(%ebp)
80101540:	e8 8b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101545:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101548:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010154a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010154d:	6a 1c                	push   $0x1c
8010154f:	50                   	push   %eax
80101550:	56                   	push   %esi
80101551:	e8 ea 32 00 00       	call   80104840 <memmove>
  brelse(bp);
80101556:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101559:	83 c4 10             	add    $0x10,%esp
}
8010155c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010155f:	5b                   	pop    %ebx
80101560:	5e                   	pop    %esi
80101561:	5d                   	pop    %ebp
  brelse(bp);
80101562:	e9 89 ec ff ff       	jmp    801001f0 <brelse>
80101567:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010156e:	66 90                	xchg   %ax,%ax

80101570 <iinit>:
{
80101570:	55                   	push   %ebp
80101571:	89 e5                	mov    %esp,%ebp
80101573:	53                   	push   %ebx
80101574:	bb a0 19 11 80       	mov    $0x801119a0,%ebx
80101579:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010157c:	68 8b 87 10 80       	push   $0x8010878b
80101581:	68 60 19 11 80       	push   $0x80111960
80101586:	e8 85 2f 00 00       	call   80104510 <initlock>
  for(i = 0; i < NINODE; i++) {
8010158b:	83 c4 10             	add    $0x10,%esp
8010158e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101590:	83 ec 08             	sub    $0x8,%esp
80101593:	68 92 87 10 80       	push   $0x80108792
80101598:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101599:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010159f:	e8 3c 2e 00 00       	call   801043e0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015a4:	83 c4 10             	add    $0x10,%esp
801015a7:	81 fb c0 35 11 80    	cmp    $0x801135c0,%ebx
801015ad:	75 e1                	jne    80101590 <iinit+0x20>
  bp = bread(dev, 1);
801015af:	83 ec 08             	sub    $0x8,%esp
801015b2:	6a 01                	push   $0x1
801015b4:	ff 75 08             	push   0x8(%ebp)
801015b7:	e8 14 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015bc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015bf:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015c1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015c4:	6a 1c                	push   $0x1c
801015c6:	50                   	push   %eax
801015c7:	68 b4 35 11 80       	push   $0x801135b4
801015cc:	e8 6f 32 00 00       	call   80104840 <memmove>
  brelse(bp);
801015d1:	89 1c 24             	mov    %ebx,(%esp)
801015d4:	e8 17 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015d9:	ff 35 cc 35 11 80    	push   0x801135cc
801015df:	ff 35 c8 35 11 80    	push   0x801135c8
801015e5:	ff 35 c4 35 11 80    	push   0x801135c4
801015eb:	ff 35 c0 35 11 80    	push   0x801135c0
801015f1:	ff 35 bc 35 11 80    	push   0x801135bc
801015f7:	ff 35 b8 35 11 80    	push   0x801135b8
801015fd:	ff 35 b4 35 11 80    	push   0x801135b4
80101603:	68 f8 87 10 80       	push   $0x801087f8
80101608:	e8 93 f0 ff ff       	call   801006a0 <cprintf>
}
8010160d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101610:	83 c4 30             	add    $0x30,%esp
80101613:	c9                   	leave  
80101614:	c3                   	ret    
80101615:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010161c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101620 <ialloc>:
{
80101620:	55                   	push   %ebp
80101621:	89 e5                	mov    %esp,%ebp
80101623:	57                   	push   %edi
80101624:	56                   	push   %esi
80101625:	53                   	push   %ebx
80101626:	83 ec 1c             	sub    $0x1c,%esp
80101629:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010162c:	83 3d bc 35 11 80 01 	cmpl   $0x1,0x801135bc
{
80101633:	8b 75 08             	mov    0x8(%ebp),%esi
80101636:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101639:	0f 86 91 00 00 00    	jbe    801016d0 <ialloc+0xb0>
8010163f:	bf 01 00 00 00       	mov    $0x1,%edi
80101644:	eb 21                	jmp    80101667 <ialloc+0x47>
80101646:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010164d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101650:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101653:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101656:	53                   	push   %ebx
80101657:	e8 94 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010165c:	83 c4 10             	add    $0x10,%esp
8010165f:	3b 3d bc 35 11 80    	cmp    0x801135bc,%edi
80101665:	73 69                	jae    801016d0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101667:	89 f8                	mov    %edi,%eax
80101669:	83 ec 08             	sub    $0x8,%esp
8010166c:	c1 e8 03             	shr    $0x3,%eax
8010166f:	03 05 c8 35 11 80    	add    0x801135c8,%eax
80101675:	50                   	push   %eax
80101676:	56                   	push   %esi
80101677:	e8 54 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010167c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010167f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101681:	89 f8                	mov    %edi,%eax
80101683:	83 e0 07             	and    $0x7,%eax
80101686:	c1 e0 06             	shl    $0x6,%eax
80101689:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010168d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101691:	75 bd                	jne    80101650 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101693:	83 ec 04             	sub    $0x4,%esp
80101696:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101699:	6a 40                	push   $0x40
8010169b:	6a 00                	push   $0x0
8010169d:	51                   	push   %ecx
8010169e:	e8 fd 30 00 00       	call   801047a0 <memset>
      dip->type = type;
801016a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016ad:	89 1c 24             	mov    %ebx,(%esp)
801016b0:	e8 9b 18 00 00       	call   80102f50 <log_write>
      brelse(bp);
801016b5:	89 1c 24             	mov    %ebx,(%esp)
801016b8:	e8 33 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016bd:	83 c4 10             	add    $0x10,%esp
}
801016c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016c3:	89 fa                	mov    %edi,%edx
}
801016c5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016c6:	89 f0                	mov    %esi,%eax
}
801016c8:	5e                   	pop    %esi
801016c9:	5f                   	pop    %edi
801016ca:	5d                   	pop    %ebp
      return iget(dev, inum);
801016cb:	e9 90 fc ff ff       	jmp    80101360 <iget>
  panic("ialloc: no inodes");
801016d0:	83 ec 0c             	sub    $0xc,%esp
801016d3:	68 98 87 10 80       	push   $0x80108798
801016d8:	e8 a3 ec ff ff       	call   80100380 <panic>
801016dd:	8d 76 00             	lea    0x0(%esi),%esi

801016e0 <iupdate>:
{
801016e0:	55                   	push   %ebp
801016e1:	89 e5                	mov    %esp,%ebp
801016e3:	56                   	push   %esi
801016e4:	53                   	push   %ebx
801016e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016e8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016eb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ee:	83 ec 08             	sub    $0x8,%esp
801016f1:	c1 e8 03             	shr    $0x3,%eax
801016f4:	03 05 c8 35 11 80    	add    0x801135c8,%eax
801016fa:	50                   	push   %eax
801016fb:	ff 73 a4             	push   -0x5c(%ebx)
801016fe:	e8 cd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101703:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101707:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010170a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010170c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010170f:	83 e0 07             	and    $0x7,%eax
80101712:	c1 e0 06             	shl    $0x6,%eax
80101715:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101719:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010171c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101720:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101723:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101727:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010172b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010172f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101733:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101737:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010173a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010173d:	6a 34                	push   $0x34
8010173f:	53                   	push   %ebx
80101740:	50                   	push   %eax
80101741:	e8 fa 30 00 00       	call   80104840 <memmove>
  log_write(bp);
80101746:	89 34 24             	mov    %esi,(%esp)
80101749:	e8 02 18 00 00       	call   80102f50 <log_write>
  brelse(bp);
8010174e:	89 75 08             	mov    %esi,0x8(%ebp)
80101751:	83 c4 10             	add    $0x10,%esp
}
80101754:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101757:	5b                   	pop    %ebx
80101758:	5e                   	pop    %esi
80101759:	5d                   	pop    %ebp
  brelse(bp);
8010175a:	e9 91 ea ff ff       	jmp    801001f0 <brelse>
8010175f:	90                   	nop

80101760 <idup>:
{
80101760:	55                   	push   %ebp
80101761:	89 e5                	mov    %esp,%ebp
80101763:	53                   	push   %ebx
80101764:	83 ec 10             	sub    $0x10,%esp
80101767:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010176a:	68 60 19 11 80       	push   $0x80111960
8010176f:	e8 6c 2f 00 00       	call   801046e0 <acquire>
  ip->ref++;
80101774:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101778:	c7 04 24 60 19 11 80 	movl   $0x80111960,(%esp)
8010177f:	e8 fc 2e 00 00       	call   80104680 <release>
}
80101784:	89 d8                	mov    %ebx,%eax
80101786:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101789:	c9                   	leave  
8010178a:	c3                   	ret    
8010178b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010178f:	90                   	nop

80101790 <ilock>:
{
80101790:	55                   	push   %ebp
80101791:	89 e5                	mov    %esp,%ebp
80101793:	56                   	push   %esi
80101794:	53                   	push   %ebx
80101795:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101798:	85 db                	test   %ebx,%ebx
8010179a:	0f 84 b7 00 00 00    	je     80101857 <ilock+0xc7>
801017a0:	8b 53 08             	mov    0x8(%ebx),%edx
801017a3:	85 d2                	test   %edx,%edx
801017a5:	0f 8e ac 00 00 00    	jle    80101857 <ilock+0xc7>
  acquiresleep(&ip->lock);
801017ab:	83 ec 0c             	sub    $0xc,%esp
801017ae:	8d 43 0c             	lea    0xc(%ebx),%eax
801017b1:	50                   	push   %eax
801017b2:	e8 69 2c 00 00       	call   80104420 <acquiresleep>
  if(ip->valid == 0){
801017b7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017ba:	83 c4 10             	add    $0x10,%esp
801017bd:	85 c0                	test   %eax,%eax
801017bf:	74 0f                	je     801017d0 <ilock+0x40>
}
801017c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017c4:	5b                   	pop    %ebx
801017c5:	5e                   	pop    %esi
801017c6:	5d                   	pop    %ebp
801017c7:	c3                   	ret    
801017c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017cf:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017d0:	8b 43 04             	mov    0x4(%ebx),%eax
801017d3:	83 ec 08             	sub    $0x8,%esp
801017d6:	c1 e8 03             	shr    $0x3,%eax
801017d9:	03 05 c8 35 11 80    	add    0x801135c8,%eax
801017df:	50                   	push   %eax
801017e0:	ff 33                	push   (%ebx)
801017e2:	e8 e9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017e7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ea:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017ec:	8b 43 04             	mov    0x4(%ebx),%eax
801017ef:	83 e0 07             	and    $0x7,%eax
801017f2:	c1 e0 06             	shl    $0x6,%eax
801017f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017f9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017fc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017ff:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101803:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101807:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010180b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010180f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101813:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101817:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010181b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010181e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101821:	6a 34                	push   $0x34
80101823:	50                   	push   %eax
80101824:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101827:	50                   	push   %eax
80101828:	e8 13 30 00 00       	call   80104840 <memmove>
    brelse(bp);
8010182d:	89 34 24             	mov    %esi,(%esp)
80101830:	e8 bb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101835:	83 c4 10             	add    $0x10,%esp
80101838:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010183d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101844:	0f 85 77 ff ff ff    	jne    801017c1 <ilock+0x31>
      panic("ilock: no type");
8010184a:	83 ec 0c             	sub    $0xc,%esp
8010184d:	68 b0 87 10 80       	push   $0x801087b0
80101852:	e8 29 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101857:	83 ec 0c             	sub    $0xc,%esp
8010185a:	68 aa 87 10 80       	push   $0x801087aa
8010185f:	e8 1c eb ff ff       	call   80100380 <panic>
80101864:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010186b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010186f:	90                   	nop

80101870 <iunlock>:
{
80101870:	55                   	push   %ebp
80101871:	89 e5                	mov    %esp,%ebp
80101873:	56                   	push   %esi
80101874:	53                   	push   %ebx
80101875:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101878:	85 db                	test   %ebx,%ebx
8010187a:	74 28                	je     801018a4 <iunlock+0x34>
8010187c:	83 ec 0c             	sub    $0xc,%esp
8010187f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101882:	56                   	push   %esi
80101883:	e8 38 2c 00 00       	call   801044c0 <holdingsleep>
80101888:	83 c4 10             	add    $0x10,%esp
8010188b:	85 c0                	test   %eax,%eax
8010188d:	74 15                	je     801018a4 <iunlock+0x34>
8010188f:	8b 43 08             	mov    0x8(%ebx),%eax
80101892:	85 c0                	test   %eax,%eax
80101894:	7e 0e                	jle    801018a4 <iunlock+0x34>
  releasesleep(&ip->lock);
80101896:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101899:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010189c:	5b                   	pop    %ebx
8010189d:	5e                   	pop    %esi
8010189e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010189f:	e9 dc 2b 00 00       	jmp    80104480 <releasesleep>
    panic("iunlock");
801018a4:	83 ec 0c             	sub    $0xc,%esp
801018a7:	68 bf 87 10 80       	push   $0x801087bf
801018ac:	e8 cf ea ff ff       	call   80100380 <panic>
801018b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018bf:	90                   	nop

801018c0 <iput>:
{
801018c0:	55                   	push   %ebp
801018c1:	89 e5                	mov    %esp,%ebp
801018c3:	57                   	push   %edi
801018c4:	56                   	push   %esi
801018c5:	53                   	push   %ebx
801018c6:	83 ec 28             	sub    $0x28,%esp
801018c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018cc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018cf:	57                   	push   %edi
801018d0:	e8 4b 2b 00 00       	call   80104420 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018d5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018d8:	83 c4 10             	add    $0x10,%esp
801018db:	85 d2                	test   %edx,%edx
801018dd:	74 07                	je     801018e6 <iput+0x26>
801018df:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018e4:	74 32                	je     80101918 <iput+0x58>
  releasesleep(&ip->lock);
801018e6:	83 ec 0c             	sub    $0xc,%esp
801018e9:	57                   	push   %edi
801018ea:	e8 91 2b 00 00       	call   80104480 <releasesleep>
  acquire(&icache.lock);
801018ef:	c7 04 24 60 19 11 80 	movl   $0x80111960,(%esp)
801018f6:	e8 e5 2d 00 00       	call   801046e0 <acquire>
  ip->ref--;
801018fb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018ff:	83 c4 10             	add    $0x10,%esp
80101902:	c7 45 08 60 19 11 80 	movl   $0x80111960,0x8(%ebp)
}
80101909:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010190c:	5b                   	pop    %ebx
8010190d:	5e                   	pop    %esi
8010190e:	5f                   	pop    %edi
8010190f:	5d                   	pop    %ebp
  release(&icache.lock);
80101910:	e9 6b 2d 00 00       	jmp    80104680 <release>
80101915:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101918:	83 ec 0c             	sub    $0xc,%esp
8010191b:	68 60 19 11 80       	push   $0x80111960
80101920:	e8 bb 2d 00 00       	call   801046e0 <acquire>
    int r = ip->ref;
80101925:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101928:	c7 04 24 60 19 11 80 	movl   $0x80111960,(%esp)
8010192f:	e8 4c 2d 00 00       	call   80104680 <release>
    if(r == 1){
80101934:	83 c4 10             	add    $0x10,%esp
80101937:	83 fe 01             	cmp    $0x1,%esi
8010193a:	75 aa                	jne    801018e6 <iput+0x26>
8010193c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101942:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101945:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101948:	89 cf                	mov    %ecx,%edi
8010194a:	eb 0b                	jmp    80101957 <iput+0x97>
8010194c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101950:	83 c6 04             	add    $0x4,%esi
80101953:	39 fe                	cmp    %edi,%esi
80101955:	74 19                	je     80101970 <iput+0xb0>
    if(ip->addrs[i]){
80101957:	8b 16                	mov    (%esi),%edx
80101959:	85 d2                	test   %edx,%edx
8010195b:	74 f3                	je     80101950 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010195d:	8b 03                	mov    (%ebx),%eax
8010195f:	e8 6c f8 ff ff       	call   801011d0 <bfree>
      ip->addrs[i] = 0;
80101964:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010196a:	eb e4                	jmp    80101950 <iput+0x90>
8010196c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101970:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101976:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101979:	85 c0                	test   %eax,%eax
8010197b:	75 2d                	jne    801019aa <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010197d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101980:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101987:	53                   	push   %ebx
80101988:	e8 53 fd ff ff       	call   801016e0 <iupdate>
      ip->type = 0;
8010198d:	31 c0                	xor    %eax,%eax
8010198f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101993:	89 1c 24             	mov    %ebx,(%esp)
80101996:	e8 45 fd ff ff       	call   801016e0 <iupdate>
      ip->valid = 0;
8010199b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801019a2:	83 c4 10             	add    $0x10,%esp
801019a5:	e9 3c ff ff ff       	jmp    801018e6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019aa:	83 ec 08             	sub    $0x8,%esp
801019ad:	50                   	push   %eax
801019ae:	ff 33                	push   (%ebx)
801019b0:	e8 1b e7 ff ff       	call   801000d0 <bread>
801019b5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019b8:	83 c4 10             	add    $0x10,%esp
801019bb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019c4:	8d 70 5c             	lea    0x5c(%eax),%esi
801019c7:	89 cf                	mov    %ecx,%edi
801019c9:	eb 0c                	jmp    801019d7 <iput+0x117>
801019cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019cf:	90                   	nop
801019d0:	83 c6 04             	add    $0x4,%esi
801019d3:	39 f7                	cmp    %esi,%edi
801019d5:	74 0f                	je     801019e6 <iput+0x126>
      if(a[j])
801019d7:	8b 16                	mov    (%esi),%edx
801019d9:	85 d2                	test   %edx,%edx
801019db:	74 f3                	je     801019d0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019dd:	8b 03                	mov    (%ebx),%eax
801019df:	e8 ec f7 ff ff       	call   801011d0 <bfree>
801019e4:	eb ea                	jmp    801019d0 <iput+0x110>
    brelse(bp);
801019e6:	83 ec 0c             	sub    $0xc,%esp
801019e9:	ff 75 e4             	push   -0x1c(%ebp)
801019ec:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019ef:	e8 fc e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019f4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019fa:	8b 03                	mov    (%ebx),%eax
801019fc:	e8 cf f7 ff ff       	call   801011d0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a01:	83 c4 10             	add    $0x10,%esp
80101a04:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a0b:	00 00 00 
80101a0e:	e9 6a ff ff ff       	jmp    8010197d <iput+0xbd>
80101a13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a20 <iunlockput>:
{
80101a20:	55                   	push   %ebp
80101a21:	89 e5                	mov    %esp,%ebp
80101a23:	56                   	push   %esi
80101a24:	53                   	push   %ebx
80101a25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a28:	85 db                	test   %ebx,%ebx
80101a2a:	74 34                	je     80101a60 <iunlockput+0x40>
80101a2c:	83 ec 0c             	sub    $0xc,%esp
80101a2f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a32:	56                   	push   %esi
80101a33:	e8 88 2a 00 00       	call   801044c0 <holdingsleep>
80101a38:	83 c4 10             	add    $0x10,%esp
80101a3b:	85 c0                	test   %eax,%eax
80101a3d:	74 21                	je     80101a60 <iunlockput+0x40>
80101a3f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a42:	85 c0                	test   %eax,%eax
80101a44:	7e 1a                	jle    80101a60 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a46:	83 ec 0c             	sub    $0xc,%esp
80101a49:	56                   	push   %esi
80101a4a:	e8 31 2a 00 00       	call   80104480 <releasesleep>
  iput(ip);
80101a4f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a52:	83 c4 10             	add    $0x10,%esp
}
80101a55:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a58:	5b                   	pop    %ebx
80101a59:	5e                   	pop    %esi
80101a5a:	5d                   	pop    %ebp
  iput(ip);
80101a5b:	e9 60 fe ff ff       	jmp    801018c0 <iput>
    panic("iunlock");
80101a60:	83 ec 0c             	sub    $0xc,%esp
80101a63:	68 bf 87 10 80       	push   $0x801087bf
80101a68:	e8 13 e9 ff ff       	call   80100380 <panic>
80101a6d:	8d 76 00             	lea    0x0(%esi),%esi

80101a70 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	8b 55 08             	mov    0x8(%ebp),%edx
80101a76:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a79:	8b 0a                	mov    (%edx),%ecx
80101a7b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a7e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a81:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a84:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a88:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a8b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a8f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a93:	8b 52 58             	mov    0x58(%edx),%edx
80101a96:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a99:	5d                   	pop    %ebp
80101a9a:	c3                   	ret    
80101a9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a9f:	90                   	nop

80101aa0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101aa0:	55                   	push   %ebp
80101aa1:	89 e5                	mov    %esp,%ebp
80101aa3:	57                   	push   %edi
80101aa4:	56                   	push   %esi
80101aa5:	53                   	push   %ebx
80101aa6:	83 ec 1c             	sub    $0x1c,%esp
80101aa9:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101aac:	8b 45 08             	mov    0x8(%ebp),%eax
80101aaf:	8b 75 10             	mov    0x10(%ebp),%esi
80101ab2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101ab5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ab8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101abd:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ac0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ac3:	0f 84 a7 00 00 00    	je     80101b70 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ac9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101acc:	8b 40 58             	mov    0x58(%eax),%eax
80101acf:	39 c6                	cmp    %eax,%esi
80101ad1:	0f 87 ba 00 00 00    	ja     80101b91 <readi+0xf1>
80101ad7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101ada:	31 c9                	xor    %ecx,%ecx
80101adc:	89 da                	mov    %ebx,%edx
80101ade:	01 f2                	add    %esi,%edx
80101ae0:	0f 92 c1             	setb   %cl
80101ae3:	89 cf                	mov    %ecx,%edi
80101ae5:	0f 82 a6 00 00 00    	jb     80101b91 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101aeb:	89 c1                	mov    %eax,%ecx
80101aed:	29 f1                	sub    %esi,%ecx
80101aef:	39 d0                	cmp    %edx,%eax
80101af1:	0f 43 cb             	cmovae %ebx,%ecx
80101af4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101af7:	85 c9                	test   %ecx,%ecx
80101af9:	74 67                	je     80101b62 <readi+0xc2>
80101afb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aff:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b00:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b03:	89 f2                	mov    %esi,%edx
80101b05:	c1 ea 09             	shr    $0x9,%edx
80101b08:	89 d8                	mov    %ebx,%eax
80101b0a:	e8 51 f9 ff ff       	call   80101460 <bmap>
80101b0f:	83 ec 08             	sub    $0x8,%esp
80101b12:	50                   	push   %eax
80101b13:	ff 33                	push   (%ebx)
80101b15:	e8 b6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b1a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b1d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b22:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b24:	89 f0                	mov    %esi,%eax
80101b26:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b2b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b2d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b30:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b32:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b36:	39 d9                	cmp    %ebx,%ecx
80101b38:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b3b:	83 c4 0c             	add    $0xc,%esp
80101b3e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b3f:	01 df                	add    %ebx,%edi
80101b41:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b43:	50                   	push   %eax
80101b44:	ff 75 e0             	push   -0x20(%ebp)
80101b47:	e8 f4 2c 00 00       	call   80104840 <memmove>
    brelse(bp);
80101b4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b4f:	89 14 24             	mov    %edx,(%esp)
80101b52:	e8 99 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b57:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b5a:	83 c4 10             	add    $0x10,%esp
80101b5d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b60:	77 9e                	ja     80101b00 <readi+0x60>
  }
  return n;
80101b62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b68:	5b                   	pop    %ebx
80101b69:	5e                   	pop    %esi
80101b6a:	5f                   	pop    %edi
80101b6b:	5d                   	pop    %ebp
80101b6c:	c3                   	ret    
80101b6d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b74:	66 83 f8 09          	cmp    $0x9,%ax
80101b78:	77 17                	ja     80101b91 <readi+0xf1>
80101b7a:	8b 04 c5 00 19 11 80 	mov    -0x7feee700(,%eax,8),%eax
80101b81:	85 c0                	test   %eax,%eax
80101b83:	74 0c                	je     80101b91 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b85:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b8b:	5b                   	pop    %ebx
80101b8c:	5e                   	pop    %esi
80101b8d:	5f                   	pop    %edi
80101b8e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b8f:	ff e0                	jmp    *%eax
      return -1;
80101b91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b96:	eb cd                	jmp    80101b65 <readi+0xc5>
80101b98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b9f:	90                   	nop

80101ba0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	57                   	push   %edi
80101ba4:	56                   	push   %esi
80101ba5:	53                   	push   %ebx
80101ba6:	83 ec 1c             	sub    $0x1c,%esp
80101ba9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bac:	8b 75 0c             	mov    0xc(%ebp),%esi
80101baf:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bb2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bb7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101bba:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bbd:	8b 75 10             	mov    0x10(%ebp),%esi
80101bc0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bc3:	0f 84 b7 00 00 00    	je     80101c80 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bc9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bcc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bcf:	0f 87 e7 00 00 00    	ja     80101cbc <writei+0x11c>
80101bd5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bd8:	31 d2                	xor    %edx,%edx
80101bda:	89 f8                	mov    %edi,%eax
80101bdc:	01 f0                	add    %esi,%eax
80101bde:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101be1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101be6:	0f 87 d0 00 00 00    	ja     80101cbc <writei+0x11c>
80101bec:	85 d2                	test   %edx,%edx
80101bee:	0f 85 c8 00 00 00    	jne    80101cbc <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bf4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bfb:	85 ff                	test   %edi,%edi
80101bfd:	74 72                	je     80101c71 <writei+0xd1>
80101bff:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c00:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101c03:	89 f2                	mov    %esi,%edx
80101c05:	c1 ea 09             	shr    $0x9,%edx
80101c08:	89 f8                	mov    %edi,%eax
80101c0a:	e8 51 f8 ff ff       	call   80101460 <bmap>
80101c0f:	83 ec 08             	sub    $0x8,%esp
80101c12:	50                   	push   %eax
80101c13:	ff 37                	push   (%edi)
80101c15:	e8 b6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c1a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c1f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c22:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c25:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c27:	89 f0                	mov    %esi,%eax
80101c29:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c2e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c30:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c34:	39 d9                	cmp    %ebx,%ecx
80101c36:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c39:	83 c4 0c             	add    $0xc,%esp
80101c3c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c3d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c3f:	ff 75 dc             	push   -0x24(%ebp)
80101c42:	50                   	push   %eax
80101c43:	e8 f8 2b 00 00       	call   80104840 <memmove>
    log_write(bp);
80101c48:	89 3c 24             	mov    %edi,(%esp)
80101c4b:	e8 00 13 00 00       	call   80102f50 <log_write>
    brelse(bp);
80101c50:	89 3c 24             	mov    %edi,(%esp)
80101c53:	e8 98 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c58:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c5b:	83 c4 10             	add    $0x10,%esp
80101c5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c61:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c64:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c67:	77 97                	ja     80101c00 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c6c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c6f:	77 37                	ja     80101ca8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c71:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c77:	5b                   	pop    %ebx
80101c78:	5e                   	pop    %esi
80101c79:	5f                   	pop    %edi
80101c7a:	5d                   	pop    %ebp
80101c7b:	c3                   	ret    
80101c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c80:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c84:	66 83 f8 09          	cmp    $0x9,%ax
80101c88:	77 32                	ja     80101cbc <writei+0x11c>
80101c8a:	8b 04 c5 04 19 11 80 	mov    -0x7feee6fc(,%eax,8),%eax
80101c91:	85 c0                	test   %eax,%eax
80101c93:	74 27                	je     80101cbc <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c95:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101c98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c9b:	5b                   	pop    %ebx
80101c9c:	5e                   	pop    %esi
80101c9d:	5f                   	pop    %edi
80101c9e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c9f:	ff e0                	jmp    *%eax
80101ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101ca8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101cab:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101cae:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101cb1:	50                   	push   %eax
80101cb2:	e8 29 fa ff ff       	call   801016e0 <iupdate>
80101cb7:	83 c4 10             	add    $0x10,%esp
80101cba:	eb b5                	jmp    80101c71 <writei+0xd1>
      return -1;
80101cbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cc1:	eb b1                	jmp    80101c74 <writei+0xd4>
80101cc3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cd0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cd0:	55                   	push   %ebp
80101cd1:	89 e5                	mov    %esp,%ebp
80101cd3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cd6:	6a 0e                	push   $0xe
80101cd8:	ff 75 0c             	push   0xc(%ebp)
80101cdb:	ff 75 08             	push   0x8(%ebp)
80101cde:	e8 cd 2b 00 00       	call   801048b0 <strncmp>
}
80101ce3:	c9                   	leave  
80101ce4:	c3                   	ret    
80101ce5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101cf0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cf0:	55                   	push   %ebp
80101cf1:	89 e5                	mov    %esp,%ebp
80101cf3:	57                   	push   %edi
80101cf4:	56                   	push   %esi
80101cf5:	53                   	push   %ebx
80101cf6:	83 ec 1c             	sub    $0x1c,%esp
80101cf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cfc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d01:	0f 85 85 00 00 00    	jne    80101d8c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d07:	8b 53 58             	mov    0x58(%ebx),%edx
80101d0a:	31 ff                	xor    %edi,%edi
80101d0c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d0f:	85 d2                	test   %edx,%edx
80101d11:	74 3e                	je     80101d51 <dirlookup+0x61>
80101d13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d17:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d18:	6a 10                	push   $0x10
80101d1a:	57                   	push   %edi
80101d1b:	56                   	push   %esi
80101d1c:	53                   	push   %ebx
80101d1d:	e8 7e fd ff ff       	call   80101aa0 <readi>
80101d22:	83 c4 10             	add    $0x10,%esp
80101d25:	83 f8 10             	cmp    $0x10,%eax
80101d28:	75 55                	jne    80101d7f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d2a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d2f:	74 18                	je     80101d49 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d31:	83 ec 04             	sub    $0x4,%esp
80101d34:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d37:	6a 0e                	push   $0xe
80101d39:	50                   	push   %eax
80101d3a:	ff 75 0c             	push   0xc(%ebp)
80101d3d:	e8 6e 2b 00 00       	call   801048b0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d42:	83 c4 10             	add    $0x10,%esp
80101d45:	85 c0                	test   %eax,%eax
80101d47:	74 17                	je     80101d60 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d49:	83 c7 10             	add    $0x10,%edi
80101d4c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d4f:	72 c7                	jb     80101d18 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d54:	31 c0                	xor    %eax,%eax
}
80101d56:	5b                   	pop    %ebx
80101d57:	5e                   	pop    %esi
80101d58:	5f                   	pop    %edi
80101d59:	5d                   	pop    %ebp
80101d5a:	c3                   	ret    
80101d5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d5f:	90                   	nop
      if(poff)
80101d60:	8b 45 10             	mov    0x10(%ebp),%eax
80101d63:	85 c0                	test   %eax,%eax
80101d65:	74 05                	je     80101d6c <dirlookup+0x7c>
        *poff = off;
80101d67:	8b 45 10             	mov    0x10(%ebp),%eax
80101d6a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d6c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d70:	8b 03                	mov    (%ebx),%eax
80101d72:	e8 e9 f5 ff ff       	call   80101360 <iget>
}
80101d77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d7a:	5b                   	pop    %ebx
80101d7b:	5e                   	pop    %esi
80101d7c:	5f                   	pop    %edi
80101d7d:	5d                   	pop    %ebp
80101d7e:	c3                   	ret    
      panic("dirlookup read");
80101d7f:	83 ec 0c             	sub    $0xc,%esp
80101d82:	68 d9 87 10 80       	push   $0x801087d9
80101d87:	e8 f4 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d8c:	83 ec 0c             	sub    $0xc,%esp
80101d8f:	68 c7 87 10 80       	push   $0x801087c7
80101d94:	e8 e7 e5 ff ff       	call   80100380 <panic>
80101d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101da0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101da0:	55                   	push   %ebp
80101da1:	89 e5                	mov    %esp,%ebp
80101da3:	57                   	push   %edi
80101da4:	56                   	push   %esi
80101da5:	53                   	push   %ebx
80101da6:	89 c3                	mov    %eax,%ebx
80101da8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101dab:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101dae:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101db1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101db4:	0f 84 64 01 00 00    	je     80101f1e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101dba:	e8 21 1c 00 00       	call   801039e0 <myproc>
  acquire(&icache.lock);
80101dbf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101dc2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101dc5:	68 60 19 11 80       	push   $0x80111960
80101dca:	e8 11 29 00 00       	call   801046e0 <acquire>
  ip->ref++;
80101dcf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dd3:	c7 04 24 60 19 11 80 	movl   $0x80111960,(%esp)
80101dda:	e8 a1 28 00 00       	call   80104680 <release>
80101ddf:	83 c4 10             	add    $0x10,%esp
80101de2:	eb 07                	jmp    80101deb <namex+0x4b>
80101de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101de8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101deb:	0f b6 03             	movzbl (%ebx),%eax
80101dee:	3c 2f                	cmp    $0x2f,%al
80101df0:	74 f6                	je     80101de8 <namex+0x48>
  if(*path == 0)
80101df2:	84 c0                	test   %al,%al
80101df4:	0f 84 06 01 00 00    	je     80101f00 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dfa:	0f b6 03             	movzbl (%ebx),%eax
80101dfd:	84 c0                	test   %al,%al
80101dff:	0f 84 10 01 00 00    	je     80101f15 <namex+0x175>
80101e05:	89 df                	mov    %ebx,%edi
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	0f 84 06 01 00 00    	je     80101f15 <namex+0x175>
80101e0f:	90                   	nop
80101e10:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e14:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e17:	3c 2f                	cmp    $0x2f,%al
80101e19:	74 04                	je     80101e1f <namex+0x7f>
80101e1b:	84 c0                	test   %al,%al
80101e1d:	75 f1                	jne    80101e10 <namex+0x70>
  len = path - s;
80101e1f:	89 f8                	mov    %edi,%eax
80101e21:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e23:	83 f8 0d             	cmp    $0xd,%eax
80101e26:	0f 8e ac 00 00 00    	jle    80101ed8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e2c:	83 ec 04             	sub    $0x4,%esp
80101e2f:	6a 0e                	push   $0xe
80101e31:	53                   	push   %ebx
    path++;
80101e32:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e34:	ff 75 e4             	push   -0x1c(%ebp)
80101e37:	e8 04 2a 00 00       	call   80104840 <memmove>
80101e3c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e3f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e42:	75 0c                	jne    80101e50 <namex+0xb0>
80101e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e48:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e4b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e4e:	74 f8                	je     80101e48 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e50:	83 ec 0c             	sub    $0xc,%esp
80101e53:	56                   	push   %esi
80101e54:	e8 37 f9 ff ff       	call   80101790 <ilock>
    if(ip->type != T_DIR){
80101e59:	83 c4 10             	add    $0x10,%esp
80101e5c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e61:	0f 85 cd 00 00 00    	jne    80101f34 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e67:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e6a:	85 c0                	test   %eax,%eax
80101e6c:	74 09                	je     80101e77 <namex+0xd7>
80101e6e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e71:	0f 84 22 01 00 00    	je     80101f99 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e77:	83 ec 04             	sub    $0x4,%esp
80101e7a:	6a 00                	push   $0x0
80101e7c:	ff 75 e4             	push   -0x1c(%ebp)
80101e7f:	56                   	push   %esi
80101e80:	e8 6b fe ff ff       	call   80101cf0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e85:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101e88:	83 c4 10             	add    $0x10,%esp
80101e8b:	89 c7                	mov    %eax,%edi
80101e8d:	85 c0                	test   %eax,%eax
80101e8f:	0f 84 e1 00 00 00    	je     80101f76 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e95:	83 ec 0c             	sub    $0xc,%esp
80101e98:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101e9b:	52                   	push   %edx
80101e9c:	e8 1f 26 00 00       	call   801044c0 <holdingsleep>
80101ea1:	83 c4 10             	add    $0x10,%esp
80101ea4:	85 c0                	test   %eax,%eax
80101ea6:	0f 84 30 01 00 00    	je     80101fdc <namex+0x23c>
80101eac:	8b 56 08             	mov    0x8(%esi),%edx
80101eaf:	85 d2                	test   %edx,%edx
80101eb1:	0f 8e 25 01 00 00    	jle    80101fdc <namex+0x23c>
  releasesleep(&ip->lock);
80101eb7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eba:	83 ec 0c             	sub    $0xc,%esp
80101ebd:	52                   	push   %edx
80101ebe:	e8 bd 25 00 00       	call   80104480 <releasesleep>
  iput(ip);
80101ec3:	89 34 24             	mov    %esi,(%esp)
80101ec6:	89 fe                	mov    %edi,%esi
80101ec8:	e8 f3 f9 ff ff       	call   801018c0 <iput>
80101ecd:	83 c4 10             	add    $0x10,%esp
80101ed0:	e9 16 ff ff ff       	jmp    80101deb <namex+0x4b>
80101ed5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ed8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101edb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101ede:	83 ec 04             	sub    $0x4,%esp
80101ee1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ee4:	50                   	push   %eax
80101ee5:	53                   	push   %ebx
    name[len] = 0;
80101ee6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ee8:	ff 75 e4             	push   -0x1c(%ebp)
80101eeb:	e8 50 29 00 00       	call   80104840 <memmove>
    name[len] = 0;
80101ef0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ef3:	83 c4 10             	add    $0x10,%esp
80101ef6:	c6 02 00             	movb   $0x0,(%edx)
80101ef9:	e9 41 ff ff ff       	jmp    80101e3f <namex+0x9f>
80101efe:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101f00:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f03:	85 c0                	test   %eax,%eax
80101f05:	0f 85 be 00 00 00    	jne    80101fc9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f0e:	89 f0                	mov    %esi,%eax
80101f10:	5b                   	pop    %ebx
80101f11:	5e                   	pop    %esi
80101f12:	5f                   	pop    %edi
80101f13:	5d                   	pop    %ebp
80101f14:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f15:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f18:	89 df                	mov    %ebx,%edi
80101f1a:	31 c0                	xor    %eax,%eax
80101f1c:	eb c0                	jmp    80101ede <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f1e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f23:	b8 01 00 00 00       	mov    $0x1,%eax
80101f28:	e8 33 f4 ff ff       	call   80101360 <iget>
80101f2d:	89 c6                	mov    %eax,%esi
80101f2f:	e9 b7 fe ff ff       	jmp    80101deb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f34:	83 ec 0c             	sub    $0xc,%esp
80101f37:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f3a:	53                   	push   %ebx
80101f3b:	e8 80 25 00 00       	call   801044c0 <holdingsleep>
80101f40:	83 c4 10             	add    $0x10,%esp
80101f43:	85 c0                	test   %eax,%eax
80101f45:	0f 84 91 00 00 00    	je     80101fdc <namex+0x23c>
80101f4b:	8b 46 08             	mov    0x8(%esi),%eax
80101f4e:	85 c0                	test   %eax,%eax
80101f50:	0f 8e 86 00 00 00    	jle    80101fdc <namex+0x23c>
  releasesleep(&ip->lock);
80101f56:	83 ec 0c             	sub    $0xc,%esp
80101f59:	53                   	push   %ebx
80101f5a:	e8 21 25 00 00       	call   80104480 <releasesleep>
  iput(ip);
80101f5f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f62:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f64:	e8 57 f9 ff ff       	call   801018c0 <iput>
      return 0;
80101f69:	83 c4 10             	add    $0x10,%esp
}
80101f6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f6f:	89 f0                	mov    %esi,%eax
80101f71:	5b                   	pop    %ebx
80101f72:	5e                   	pop    %esi
80101f73:	5f                   	pop    %edi
80101f74:	5d                   	pop    %ebp
80101f75:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f76:	83 ec 0c             	sub    $0xc,%esp
80101f79:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f7c:	52                   	push   %edx
80101f7d:	e8 3e 25 00 00       	call   801044c0 <holdingsleep>
80101f82:	83 c4 10             	add    $0x10,%esp
80101f85:	85 c0                	test   %eax,%eax
80101f87:	74 53                	je     80101fdc <namex+0x23c>
80101f89:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f8c:	85 c9                	test   %ecx,%ecx
80101f8e:	7e 4c                	jle    80101fdc <namex+0x23c>
  releasesleep(&ip->lock);
80101f90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f93:	83 ec 0c             	sub    $0xc,%esp
80101f96:	52                   	push   %edx
80101f97:	eb c1                	jmp    80101f5a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f99:	83 ec 0c             	sub    $0xc,%esp
80101f9c:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f9f:	53                   	push   %ebx
80101fa0:	e8 1b 25 00 00       	call   801044c0 <holdingsleep>
80101fa5:	83 c4 10             	add    $0x10,%esp
80101fa8:	85 c0                	test   %eax,%eax
80101faa:	74 30                	je     80101fdc <namex+0x23c>
80101fac:	8b 7e 08             	mov    0x8(%esi),%edi
80101faf:	85 ff                	test   %edi,%edi
80101fb1:	7e 29                	jle    80101fdc <namex+0x23c>
  releasesleep(&ip->lock);
80101fb3:	83 ec 0c             	sub    $0xc,%esp
80101fb6:	53                   	push   %ebx
80101fb7:	e8 c4 24 00 00       	call   80104480 <releasesleep>
}
80101fbc:	83 c4 10             	add    $0x10,%esp
}
80101fbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fc2:	89 f0                	mov    %esi,%eax
80101fc4:	5b                   	pop    %ebx
80101fc5:	5e                   	pop    %esi
80101fc6:	5f                   	pop    %edi
80101fc7:	5d                   	pop    %ebp
80101fc8:	c3                   	ret    
    iput(ip);
80101fc9:	83 ec 0c             	sub    $0xc,%esp
80101fcc:	56                   	push   %esi
    return 0;
80101fcd:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fcf:	e8 ec f8 ff ff       	call   801018c0 <iput>
    return 0;
80101fd4:	83 c4 10             	add    $0x10,%esp
80101fd7:	e9 2f ff ff ff       	jmp    80101f0b <namex+0x16b>
    panic("iunlock");
80101fdc:	83 ec 0c             	sub    $0xc,%esp
80101fdf:	68 bf 87 10 80       	push   $0x801087bf
80101fe4:	e8 97 e3 ff ff       	call   80100380 <panic>
80101fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101ff0 <dirlink>:
{
80101ff0:	55                   	push   %ebp
80101ff1:	89 e5                	mov    %esp,%ebp
80101ff3:	57                   	push   %edi
80101ff4:	56                   	push   %esi
80101ff5:	53                   	push   %ebx
80101ff6:	83 ec 20             	sub    $0x20,%esp
80101ff9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101ffc:	6a 00                	push   $0x0
80101ffe:	ff 75 0c             	push   0xc(%ebp)
80102001:	53                   	push   %ebx
80102002:	e8 e9 fc ff ff       	call   80101cf0 <dirlookup>
80102007:	83 c4 10             	add    $0x10,%esp
8010200a:	85 c0                	test   %eax,%eax
8010200c:	75 67                	jne    80102075 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010200e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102011:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102014:	85 ff                	test   %edi,%edi
80102016:	74 29                	je     80102041 <dirlink+0x51>
80102018:	31 ff                	xor    %edi,%edi
8010201a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010201d:	eb 09                	jmp    80102028 <dirlink+0x38>
8010201f:	90                   	nop
80102020:	83 c7 10             	add    $0x10,%edi
80102023:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102026:	73 19                	jae    80102041 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102028:	6a 10                	push   $0x10
8010202a:	57                   	push   %edi
8010202b:	56                   	push   %esi
8010202c:	53                   	push   %ebx
8010202d:	e8 6e fa ff ff       	call   80101aa0 <readi>
80102032:	83 c4 10             	add    $0x10,%esp
80102035:	83 f8 10             	cmp    $0x10,%eax
80102038:	75 4e                	jne    80102088 <dirlink+0x98>
    if(de.inum == 0)
8010203a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010203f:	75 df                	jne    80102020 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102041:	83 ec 04             	sub    $0x4,%esp
80102044:	8d 45 da             	lea    -0x26(%ebp),%eax
80102047:	6a 0e                	push   $0xe
80102049:	ff 75 0c             	push   0xc(%ebp)
8010204c:	50                   	push   %eax
8010204d:	e8 ae 28 00 00       	call   80104900 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102052:	6a 10                	push   $0x10
  de.inum = inum;
80102054:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102057:	57                   	push   %edi
80102058:	56                   	push   %esi
80102059:	53                   	push   %ebx
  de.inum = inum;
8010205a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010205e:	e8 3d fb ff ff       	call   80101ba0 <writei>
80102063:	83 c4 20             	add    $0x20,%esp
80102066:	83 f8 10             	cmp    $0x10,%eax
80102069:	75 2a                	jne    80102095 <dirlink+0xa5>
  return 0;
8010206b:	31 c0                	xor    %eax,%eax
}
8010206d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102070:	5b                   	pop    %ebx
80102071:	5e                   	pop    %esi
80102072:	5f                   	pop    %edi
80102073:	5d                   	pop    %ebp
80102074:	c3                   	ret    
    iput(ip);
80102075:	83 ec 0c             	sub    $0xc,%esp
80102078:	50                   	push   %eax
80102079:	e8 42 f8 ff ff       	call   801018c0 <iput>
    return -1;
8010207e:	83 c4 10             	add    $0x10,%esp
80102081:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102086:	eb e5                	jmp    8010206d <dirlink+0x7d>
      panic("dirlink read");
80102088:	83 ec 0c             	sub    $0xc,%esp
8010208b:	68 e8 87 10 80       	push   $0x801087e8
80102090:	e8 eb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102095:	83 ec 0c             	sub    $0xc,%esp
80102098:	68 ee 8d 10 80       	push   $0x80108dee
8010209d:	e8 de e2 ff ff       	call   80100380 <panic>
801020a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020b0 <namei>:

struct inode*
namei(char *path)
{
801020b0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020b1:	31 d2                	xor    %edx,%edx
{
801020b3:	89 e5                	mov    %esp,%ebp
801020b5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020b8:	8b 45 08             	mov    0x8(%ebp),%eax
801020bb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020be:	e8 dd fc ff ff       	call   80101da0 <namex>
}
801020c3:	c9                   	leave  
801020c4:	c3                   	ret    
801020c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020d0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020d0:	55                   	push   %ebp
  return namex(path, 1, name);
801020d1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020d6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020db:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020de:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020df:	e9 bc fc ff ff       	jmp    80101da0 <namex>
801020e4:	66 90                	xchg   %ax,%ax
801020e6:	66 90                	xchg   %ax,%ax
801020e8:	66 90                	xchg   %ax,%ax
801020ea:	66 90                	xchg   %ax,%ax
801020ec:	66 90                	xchg   %ax,%ax
801020ee:	66 90                	xchg   %ax,%ax

801020f0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020f0:	55                   	push   %ebp
801020f1:	89 e5                	mov    %esp,%ebp
801020f3:	57                   	push   %edi
801020f4:	56                   	push   %esi
801020f5:	53                   	push   %ebx
801020f6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020f9:	85 c0                	test   %eax,%eax
801020fb:	0f 84 b4 00 00 00    	je     801021b5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102101:	8b 70 08             	mov    0x8(%eax),%esi
80102104:	89 c3                	mov    %eax,%ebx
80102106:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010210c:	0f 87 96 00 00 00    	ja     801021a8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102112:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102117:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010211e:	66 90                	xchg   %ax,%ax
80102120:	89 ca                	mov    %ecx,%edx
80102122:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102123:	83 e0 c0             	and    $0xffffffc0,%eax
80102126:	3c 40                	cmp    $0x40,%al
80102128:	75 f6                	jne    80102120 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010212a:	31 ff                	xor    %edi,%edi
8010212c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102131:	89 f8                	mov    %edi,%eax
80102133:	ee                   	out    %al,(%dx)
80102134:	b8 01 00 00 00       	mov    $0x1,%eax
80102139:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010213e:	ee                   	out    %al,(%dx)
8010213f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102144:	89 f0                	mov    %esi,%eax
80102146:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102147:	89 f0                	mov    %esi,%eax
80102149:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010214e:	c1 f8 08             	sar    $0x8,%eax
80102151:	ee                   	out    %al,(%dx)
80102152:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102157:	89 f8                	mov    %edi,%eax
80102159:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010215a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010215e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102163:	c1 e0 04             	shl    $0x4,%eax
80102166:	83 e0 10             	and    $0x10,%eax
80102169:	83 c8 e0             	or     $0xffffffe0,%eax
8010216c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010216d:	f6 03 04             	testb  $0x4,(%ebx)
80102170:	75 16                	jne    80102188 <idestart+0x98>
80102172:	b8 20 00 00 00       	mov    $0x20,%eax
80102177:	89 ca                	mov    %ecx,%edx
80102179:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010217a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010217d:	5b                   	pop    %ebx
8010217e:	5e                   	pop    %esi
8010217f:	5f                   	pop    %edi
80102180:	5d                   	pop    %ebp
80102181:	c3                   	ret    
80102182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102188:	b8 30 00 00 00       	mov    $0x30,%eax
8010218d:	89 ca                	mov    %ecx,%edx
8010218f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102190:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102195:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102198:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010219d:	fc                   	cld    
8010219e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801021a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021a3:	5b                   	pop    %ebx
801021a4:	5e                   	pop    %esi
801021a5:	5f                   	pop    %edi
801021a6:	5d                   	pop    %ebp
801021a7:	c3                   	ret    
    panic("incorrect blockno");
801021a8:	83 ec 0c             	sub    $0xc,%esp
801021ab:	68 54 88 10 80       	push   $0x80108854
801021b0:	e8 cb e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021b5:	83 ec 0c             	sub    $0xc,%esp
801021b8:	68 4b 88 10 80       	push   $0x8010884b
801021bd:	e8 be e1 ff ff       	call   80100380 <panic>
801021c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021d0 <ideinit>:
{
801021d0:	55                   	push   %ebp
801021d1:	89 e5                	mov    %esp,%ebp
801021d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021d6:	68 66 88 10 80       	push   $0x80108866
801021db:	68 00 36 11 80       	push   $0x80113600
801021e0:	e8 2b 23 00 00       	call   80104510 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021e5:	58                   	pop    %eax
801021e6:	a1 a4 37 21 80       	mov    0x802137a4,%eax
801021eb:	5a                   	pop    %edx
801021ec:	83 e8 01             	sub    $0x1,%eax
801021ef:	50                   	push   %eax
801021f0:	6a 0e                	push   $0xe
801021f2:	e8 99 02 00 00       	call   80102490 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021f7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021fa:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ff:	90                   	nop
80102200:	ec                   	in     (%dx),%al
80102201:	83 e0 c0             	and    $0xffffffc0,%eax
80102204:	3c 40                	cmp    $0x40,%al
80102206:	75 f8                	jne    80102200 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102208:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010220d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102212:	ee                   	out    %al,(%dx)
80102213:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102218:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010221d:	eb 06                	jmp    80102225 <ideinit+0x55>
8010221f:	90                   	nop
  for(i=0; i<1000; i++){
80102220:	83 e9 01             	sub    $0x1,%ecx
80102223:	74 0f                	je     80102234 <ideinit+0x64>
80102225:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102226:	84 c0                	test   %al,%al
80102228:	74 f6                	je     80102220 <ideinit+0x50>
      havedisk1 = 1;
8010222a:	c7 05 e0 35 11 80 01 	movl   $0x1,0x801135e0
80102231:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102234:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102239:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010223e:	ee                   	out    %al,(%dx)
}
8010223f:	c9                   	leave  
80102240:	c3                   	ret    
80102241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102248:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010224f:	90                   	nop

80102250 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102250:	55                   	push   %ebp
80102251:	89 e5                	mov    %esp,%ebp
80102253:	57                   	push   %edi
80102254:	56                   	push   %esi
80102255:	53                   	push   %ebx
80102256:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102259:	68 00 36 11 80       	push   $0x80113600
8010225e:	e8 7d 24 00 00       	call   801046e0 <acquire>

  if((b = idequeue) == 0){
80102263:	8b 1d e4 35 11 80    	mov    0x801135e4,%ebx
80102269:	83 c4 10             	add    $0x10,%esp
8010226c:	85 db                	test   %ebx,%ebx
8010226e:	74 63                	je     801022d3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102270:	8b 43 58             	mov    0x58(%ebx),%eax
80102273:	a3 e4 35 11 80       	mov    %eax,0x801135e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102278:	8b 33                	mov    (%ebx),%esi
8010227a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102280:	75 2f                	jne    801022b1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102282:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102287:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010228e:	66 90                	xchg   %ax,%ax
80102290:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102291:	89 c1                	mov    %eax,%ecx
80102293:	83 e1 c0             	and    $0xffffffc0,%ecx
80102296:	80 f9 40             	cmp    $0x40,%cl
80102299:	75 f5                	jne    80102290 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010229b:	a8 21                	test   $0x21,%al
8010229d:	75 12                	jne    801022b1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010229f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801022a2:	b9 80 00 00 00       	mov    $0x80,%ecx
801022a7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022ac:	fc                   	cld    
801022ad:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801022af:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022b1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022b4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022b7:	83 ce 02             	or     $0x2,%esi
801022ba:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022bc:	53                   	push   %ebx
801022bd:	e8 7e 1f 00 00       	call   80104240 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022c2:	a1 e4 35 11 80       	mov    0x801135e4,%eax
801022c7:	83 c4 10             	add    $0x10,%esp
801022ca:	85 c0                	test   %eax,%eax
801022cc:	74 05                	je     801022d3 <ideintr+0x83>
    idestart(idequeue);
801022ce:	e8 1d fe ff ff       	call   801020f0 <idestart>
    release(&idelock);
801022d3:	83 ec 0c             	sub    $0xc,%esp
801022d6:	68 00 36 11 80       	push   $0x80113600
801022db:	e8 a0 23 00 00       	call   80104680 <release>

  release(&idelock);
}
801022e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022e3:	5b                   	pop    %ebx
801022e4:	5e                   	pop    %esi
801022e5:	5f                   	pop    %edi
801022e6:	5d                   	pop    %ebp
801022e7:	c3                   	ret    
801022e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ef:	90                   	nop

801022f0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022f0:	55                   	push   %ebp
801022f1:	89 e5                	mov    %esp,%ebp
801022f3:	53                   	push   %ebx
801022f4:	83 ec 10             	sub    $0x10,%esp
801022f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022fa:	8d 43 0c             	lea    0xc(%ebx),%eax
801022fd:	50                   	push   %eax
801022fe:	e8 bd 21 00 00       	call   801044c0 <holdingsleep>
80102303:	83 c4 10             	add    $0x10,%esp
80102306:	85 c0                	test   %eax,%eax
80102308:	0f 84 c3 00 00 00    	je     801023d1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010230e:	8b 03                	mov    (%ebx),%eax
80102310:	83 e0 06             	and    $0x6,%eax
80102313:	83 f8 02             	cmp    $0x2,%eax
80102316:	0f 84 a8 00 00 00    	je     801023c4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010231c:	8b 53 04             	mov    0x4(%ebx),%edx
8010231f:	85 d2                	test   %edx,%edx
80102321:	74 0d                	je     80102330 <iderw+0x40>
80102323:	a1 e0 35 11 80       	mov    0x801135e0,%eax
80102328:	85 c0                	test   %eax,%eax
8010232a:	0f 84 87 00 00 00    	je     801023b7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102330:	83 ec 0c             	sub    $0xc,%esp
80102333:	68 00 36 11 80       	push   $0x80113600
80102338:	e8 a3 23 00 00       	call   801046e0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010233d:	a1 e4 35 11 80       	mov    0x801135e4,%eax
  b->qnext = 0;
80102342:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102349:	83 c4 10             	add    $0x10,%esp
8010234c:	85 c0                	test   %eax,%eax
8010234e:	74 60                	je     801023b0 <iderw+0xc0>
80102350:	89 c2                	mov    %eax,%edx
80102352:	8b 40 58             	mov    0x58(%eax),%eax
80102355:	85 c0                	test   %eax,%eax
80102357:	75 f7                	jne    80102350 <iderw+0x60>
80102359:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010235c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010235e:	39 1d e4 35 11 80    	cmp    %ebx,0x801135e4
80102364:	74 3a                	je     801023a0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102366:	8b 03                	mov    (%ebx),%eax
80102368:	83 e0 06             	and    $0x6,%eax
8010236b:	83 f8 02             	cmp    $0x2,%eax
8010236e:	74 1b                	je     8010238b <iderw+0x9b>
    sleep(b, &idelock);
80102370:	83 ec 08             	sub    $0x8,%esp
80102373:	68 00 36 11 80       	push   $0x80113600
80102378:	53                   	push   %ebx
80102379:	e8 02 1e 00 00       	call   80104180 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010237e:	8b 03                	mov    (%ebx),%eax
80102380:	83 c4 10             	add    $0x10,%esp
80102383:	83 e0 06             	and    $0x6,%eax
80102386:	83 f8 02             	cmp    $0x2,%eax
80102389:	75 e5                	jne    80102370 <iderw+0x80>
  }


  release(&idelock);
8010238b:	c7 45 08 00 36 11 80 	movl   $0x80113600,0x8(%ebp)
}
80102392:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102395:	c9                   	leave  
  release(&idelock);
80102396:	e9 e5 22 00 00       	jmp    80104680 <release>
8010239b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010239f:	90                   	nop
    idestart(b);
801023a0:	89 d8                	mov    %ebx,%eax
801023a2:	e8 49 fd ff ff       	call   801020f0 <idestart>
801023a7:	eb bd                	jmp    80102366 <iderw+0x76>
801023a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023b0:	ba e4 35 11 80       	mov    $0x801135e4,%edx
801023b5:	eb a5                	jmp    8010235c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023b7:	83 ec 0c             	sub    $0xc,%esp
801023ba:	68 95 88 10 80       	push   $0x80108895
801023bf:	e8 bc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023c4:	83 ec 0c             	sub    $0xc,%esp
801023c7:	68 80 88 10 80       	push   $0x80108880
801023cc:	e8 af df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023d1:	83 ec 0c             	sub    $0xc,%esp
801023d4:	68 6a 88 10 80       	push   $0x8010886a
801023d9:	e8 a2 df ff ff       	call   80100380 <panic>
801023de:	66 90                	xchg   %ax,%ax

801023e0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023e0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023e1:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
801023e8:	00 c0 fe 
{
801023eb:	89 e5                	mov    %esp,%ebp
801023ed:	56                   	push   %esi
801023ee:	53                   	push   %ebx
  ioapic->reg = reg;
801023ef:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023f6:	00 00 00 
  return ioapic->data;
801023f9:	8b 15 34 36 11 80    	mov    0x80113634,%edx
801023ff:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102402:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102408:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010240e:	0f b6 15 a0 37 21 80 	movzbl 0x802137a0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102415:	c1 ee 10             	shr    $0x10,%esi
80102418:	89 f0                	mov    %esi,%eax
8010241a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010241d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102420:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102423:	39 c2                	cmp    %eax,%edx
80102425:	74 16                	je     8010243d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102427:	83 ec 0c             	sub    $0xc,%esp
8010242a:	68 b4 88 10 80       	push   $0x801088b4
8010242f:	e8 6c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102434:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
8010243a:	83 c4 10             	add    $0x10,%esp
8010243d:	83 c6 21             	add    $0x21,%esi
{
80102440:	ba 10 00 00 00       	mov    $0x10,%edx
80102445:	b8 20 00 00 00       	mov    $0x20,%eax
8010244a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102450:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102452:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102454:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  for(i = 0; i <= maxintr; i++){
8010245a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010245d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102463:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102466:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102469:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010246c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010246e:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
80102474:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010247b:	39 f0                	cmp    %esi,%eax
8010247d:	75 d1                	jne    80102450 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010247f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102482:	5b                   	pop    %ebx
80102483:	5e                   	pop    %esi
80102484:	5d                   	pop    %ebp
80102485:	c3                   	ret    
80102486:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010248d:	8d 76 00             	lea    0x0(%esi),%esi

80102490 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102490:	55                   	push   %ebp
  ioapic->reg = reg;
80102491:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
{
80102497:	89 e5                	mov    %esp,%ebp
80102499:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010249c:	8d 50 20             	lea    0x20(%eax),%edx
8010249f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801024a3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a5:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024ab:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801024ae:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024b4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024b6:	a1 34 36 11 80       	mov    0x80113634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024bb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024be:	89 50 10             	mov    %edx,0x10(%eax)
}
801024c1:	5d                   	pop    %ebp
801024c2:	c3                   	ret    
801024c3:	66 90                	xchg   %ax,%ax
801024c5:	66 90                	xchg   %ax,%ax
801024c7:	66 90                	xchg   %ax,%ax
801024c9:	66 90                	xchg   %ax,%ax
801024cb:	66 90                	xchg   %ax,%ax
801024cd:	66 90                	xchg   %ax,%ax
801024cf:	90                   	nop

801024d0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024d0:	55                   	push   %ebp
801024d1:	89 e5                	mov    %esp,%ebp
801024d3:	53                   	push   %ebx
801024d4:	83 ec 04             	sub    $0x4,%esp
801024d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024da:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024e0:	75 76                	jne    80102558 <kfree+0x88>
801024e2:	81 fb 40 c6 21 80    	cmp    $0x8021c640,%ebx
801024e8:	72 6e                	jb     80102558 <kfree+0x88>
801024ea:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024f0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024f5:	77 61                	ja     80102558 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024f7:	83 ec 04             	sub    $0x4,%esp
801024fa:	68 00 10 00 00       	push   $0x1000
801024ff:	6a 01                	push   $0x1
80102501:	53                   	push   %ebx
80102502:	e8 99 22 00 00       	call   801047a0 <memset>

  if(kmem.use_lock)
80102507:	8b 15 74 36 11 80    	mov    0x80113674,%edx
8010250d:	83 c4 10             	add    $0x10,%esp
80102510:	85 d2                	test   %edx,%edx
80102512:	75 1c                	jne    80102530 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102514:	a1 78 36 11 80       	mov    0x80113678,%eax
80102519:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010251b:	a1 74 36 11 80       	mov    0x80113674,%eax
  kmem.freelist = r;
80102520:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
80102526:	85 c0                	test   %eax,%eax
80102528:	75 1e                	jne    80102548 <kfree+0x78>
    release(&kmem.lock);
}
8010252a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010252d:	c9                   	leave  
8010252e:	c3                   	ret    
8010252f:	90                   	nop
    acquire(&kmem.lock);
80102530:	83 ec 0c             	sub    $0xc,%esp
80102533:	68 40 36 11 80       	push   $0x80113640
80102538:	e8 a3 21 00 00       	call   801046e0 <acquire>
8010253d:	83 c4 10             	add    $0x10,%esp
80102540:	eb d2                	jmp    80102514 <kfree+0x44>
80102542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102548:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
8010254f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102552:	c9                   	leave  
    release(&kmem.lock);
80102553:	e9 28 21 00 00       	jmp    80104680 <release>
    panic("kfree");
80102558:	83 ec 0c             	sub    $0xc,%esp
8010255b:	68 e9 91 10 80       	push   $0x801091e9
80102560:	e8 1b de ff ff       	call   80100380 <panic>
80102565:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010256c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102570 <freerange>:
{
80102570:	55                   	push   %ebp
80102571:	89 e5                	mov    %esp,%ebp
80102573:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102574:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102577:	8b 75 0c             	mov    0xc(%ebp),%esi
8010257a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010257b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102581:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102587:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010258d:	39 de                	cmp    %ebx,%esi
8010258f:	72 23                	jb     801025b4 <freerange+0x44>
80102591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102598:	83 ec 0c             	sub    $0xc,%esp
8010259b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025a7:	50                   	push   %eax
801025a8:	e8 23 ff ff ff       	call   801024d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ad:	83 c4 10             	add    $0x10,%esp
801025b0:	39 f3                	cmp    %esi,%ebx
801025b2:	76 e4                	jbe    80102598 <freerange+0x28>
}
801025b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025b7:	5b                   	pop    %ebx
801025b8:	5e                   	pop    %esi
801025b9:	5d                   	pop    %ebp
801025ba:	c3                   	ret    
801025bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025bf:	90                   	nop

801025c0 <kinit2>:
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025c4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025c7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ca:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025dd:	39 de                	cmp    %ebx,%esi
801025df:	72 23                	jb     80102604 <kinit2+0x44>
801025e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025e8:	83 ec 0c             	sub    $0xc,%esp
801025eb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025f7:	50                   	push   %eax
801025f8:	e8 d3 fe ff ff       	call   801024d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025fd:	83 c4 10             	add    $0x10,%esp
80102600:	39 de                	cmp    %ebx,%esi
80102602:	73 e4                	jae    801025e8 <kinit2+0x28>
  kmem.use_lock = 1;
80102604:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
8010260b:	00 00 00 
}
8010260e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102611:	5b                   	pop    %ebx
80102612:	5e                   	pop    %esi
80102613:	5d                   	pop    %ebp
80102614:	c3                   	ret    
80102615:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010261c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102620 <kinit1>:
{
80102620:	55                   	push   %ebp
80102621:	89 e5                	mov    %esp,%ebp
80102623:	56                   	push   %esi
80102624:	53                   	push   %ebx
80102625:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102628:	83 ec 08             	sub    $0x8,%esp
8010262b:	68 e6 88 10 80       	push   $0x801088e6
80102630:	68 40 36 11 80       	push   $0x80113640
80102635:	e8 d6 1e 00 00       	call   80104510 <initlock>
  kmem.use_lock = 0;
8010263a:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
80102641:	00 00 00 
  init_cow();
80102644:	e8 e7 47 00 00       	call   80106e30 <init_cow>
  p = (char*)PGROUNDUP((uint)vstart);
80102649:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010264c:	83 c4 10             	add    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
8010264f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102655:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010265b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102661:	39 de                	cmp    %ebx,%esi
80102663:	72 1f                	jb     80102684 <kinit1+0x64>
80102665:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102668:	83 ec 0c             	sub    $0xc,%esp
8010266b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102671:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102677:	50                   	push   %eax
80102678:	e8 53 fe ff ff       	call   801024d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010267d:	83 c4 10             	add    $0x10,%esp
80102680:	39 de                	cmp    %ebx,%esi
80102682:	73 e4                	jae    80102668 <kinit1+0x48>
}
80102684:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102687:	5b                   	pop    %ebx
80102688:	5e                   	pop    %esi
80102689:	5d                   	pop    %ebp
8010268a:	c3                   	ret    
8010268b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010268f:	90                   	nop

80102690 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102690:	a1 74 36 11 80       	mov    0x80113674,%eax
80102695:	85 c0                	test   %eax,%eax
80102697:	75 1f                	jne    801026b8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102699:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
8010269e:	85 c0                	test   %eax,%eax
801026a0:	74 0e                	je     801026b0 <kalloc+0x20>
    kmem.freelist = r->next;
801026a2:	8b 10                	mov    (%eax),%edx
801026a4:	89 15 78 36 11 80    	mov    %edx,0x80113678
  if(kmem.use_lock)
801026aa:	c3                   	ret    
801026ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026af:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801026b0:	c3                   	ret    
801026b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801026b8:	55                   	push   %ebp
801026b9:	89 e5                	mov    %esp,%ebp
801026bb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801026be:	68 40 36 11 80       	push   $0x80113640
801026c3:	e8 18 20 00 00       	call   801046e0 <acquire>
  r = kmem.freelist;
801026c8:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(kmem.use_lock)
801026cd:	8b 15 74 36 11 80    	mov    0x80113674,%edx
  if(r)
801026d3:	83 c4 10             	add    $0x10,%esp
801026d6:	85 c0                	test   %eax,%eax
801026d8:	74 08                	je     801026e2 <kalloc+0x52>
    kmem.freelist = r->next;
801026da:	8b 08                	mov    (%eax),%ecx
801026dc:	89 0d 78 36 11 80    	mov    %ecx,0x80113678
  if(kmem.use_lock)
801026e2:	85 d2                	test   %edx,%edx
801026e4:	74 16                	je     801026fc <kalloc+0x6c>
    release(&kmem.lock);
801026e6:	83 ec 0c             	sub    $0xc,%esp
801026e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026ec:	68 40 36 11 80       	push   $0x80113640
801026f1:	e8 8a 1f 00 00       	call   80104680 <release>
  return (char*)r;
801026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026f9:	83 c4 10             	add    $0x10,%esp
}
801026fc:	c9                   	leave  
801026fd:	c3                   	ret    
801026fe:	66 90                	xchg   %ax,%ax

80102700 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102700:	ba 64 00 00 00       	mov    $0x64,%edx
80102705:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102706:	a8 01                	test   $0x1,%al
80102708:	0f 84 c2 00 00 00    	je     801027d0 <kbdgetc+0xd0>
{
8010270e:	55                   	push   %ebp
8010270f:	ba 60 00 00 00       	mov    $0x60,%edx
80102714:	89 e5                	mov    %esp,%ebp
80102716:	53                   	push   %ebx
80102717:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102718:	8b 1d 7c 36 11 80    	mov    0x8011367c,%ebx
  data = inb(KBDATAP);
8010271e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102721:	3c e0                	cmp    $0xe0,%al
80102723:	74 5b                	je     80102780 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102725:	89 da                	mov    %ebx,%edx
80102727:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010272a:	84 c0                	test   %al,%al
8010272c:	78 62                	js     80102790 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010272e:	85 d2                	test   %edx,%edx
80102730:	74 09                	je     8010273b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102732:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102735:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102738:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010273b:	0f b6 91 20 8a 10 80 	movzbl -0x7fef75e0(%ecx),%edx
  shift ^= togglecode[data];
80102742:	0f b6 81 20 89 10 80 	movzbl -0x7fef76e0(%ecx),%eax
  shift |= shiftcode[data];
80102749:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010274b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010274d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010274f:	89 15 7c 36 11 80    	mov    %edx,0x8011367c
  c = charcode[shift & (CTL | SHIFT)][data];
80102755:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102758:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010275b:	8b 04 85 00 89 10 80 	mov    -0x7fef7700(,%eax,4),%eax
80102762:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102766:	74 0b                	je     80102773 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102768:	8d 50 9f             	lea    -0x61(%eax),%edx
8010276b:	83 fa 19             	cmp    $0x19,%edx
8010276e:	77 48                	ja     801027b8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102770:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102773:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102776:	c9                   	leave  
80102777:	c3                   	ret    
80102778:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010277f:	90                   	nop
    shift |= E0ESC;
80102780:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102783:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102785:	89 1d 7c 36 11 80    	mov    %ebx,0x8011367c
}
8010278b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010278e:	c9                   	leave  
8010278f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102790:	83 e0 7f             	and    $0x7f,%eax
80102793:	85 d2                	test   %edx,%edx
80102795:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102798:	0f b6 81 20 8a 10 80 	movzbl -0x7fef75e0(%ecx),%eax
8010279f:	83 c8 40             	or     $0x40,%eax
801027a2:	0f b6 c0             	movzbl %al,%eax
801027a5:	f7 d0                	not    %eax
801027a7:	21 d8                	and    %ebx,%eax
}
801027a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
801027ac:	a3 7c 36 11 80       	mov    %eax,0x8011367c
    return 0;
801027b1:	31 c0                	xor    %eax,%eax
}
801027b3:	c9                   	leave  
801027b4:	c3                   	ret    
801027b5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801027b8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027bb:	8d 50 20             	lea    0x20(%eax),%edx
}
801027be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027c1:	c9                   	leave  
      c += 'a' - 'A';
801027c2:	83 f9 1a             	cmp    $0x1a,%ecx
801027c5:	0f 42 c2             	cmovb  %edx,%eax
}
801027c8:	c3                   	ret    
801027c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801027d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027d5:	c3                   	ret    
801027d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027dd:	8d 76 00             	lea    0x0(%esi),%esi

801027e0 <kbdintr>:

void
kbdintr(void)
{
801027e0:	55                   	push   %ebp
801027e1:	89 e5                	mov    %esp,%ebp
801027e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027e6:	68 00 27 10 80       	push   $0x80102700
801027eb:	e8 90 e0 ff ff       	call   80100880 <consoleintr>
}
801027f0:	83 c4 10             	add    $0x10,%esp
801027f3:	c9                   	leave  
801027f4:	c3                   	ret    
801027f5:	66 90                	xchg   %ax,%ax
801027f7:	66 90                	xchg   %ax,%ax
801027f9:	66 90                	xchg   %ax,%ax
801027fb:	66 90                	xchg   %ax,%ax
801027fd:	66 90                	xchg   %ax,%ax
801027ff:	90                   	nop

80102800 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102800:	a1 80 36 11 80       	mov    0x80113680,%eax
80102805:	85 c0                	test   %eax,%eax
80102807:	0f 84 cb 00 00 00    	je     801028d8 <lapicinit+0xd8>
  lapic[index] = value;
8010280d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102814:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102817:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010281a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102821:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102824:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102827:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010282e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102831:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102834:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010283b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010283e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102841:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102848:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010284b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010284e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102855:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102858:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010285b:	8b 50 30             	mov    0x30(%eax),%edx
8010285e:	c1 ea 10             	shr    $0x10,%edx
80102861:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102867:	75 77                	jne    801028e0 <lapicinit+0xe0>
  lapic[index] = value;
80102869:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102870:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102873:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102876:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010287d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102880:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102883:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010288a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010288d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102890:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102897:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010289a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010289d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801028a4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028a7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028aa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028b1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028b4:	8b 50 20             	mov    0x20(%eax),%edx
801028b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028be:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028c0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028c6:	80 e6 10             	and    $0x10,%dh
801028c9:	75 f5                	jne    801028c0 <lapicinit+0xc0>
  lapic[index] = value;
801028cb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028d2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028d5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028d8:	c3                   	ret    
801028d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028e0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028e7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028ea:	8b 50 20             	mov    0x20(%eax),%edx
}
801028ed:	e9 77 ff ff ff       	jmp    80102869 <lapicinit+0x69>
801028f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102900 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102900:	a1 80 36 11 80       	mov    0x80113680,%eax
80102905:	85 c0                	test   %eax,%eax
80102907:	74 07                	je     80102910 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102909:	8b 40 20             	mov    0x20(%eax),%eax
8010290c:	c1 e8 18             	shr    $0x18,%eax
8010290f:	c3                   	ret    
    return 0;
80102910:	31 c0                	xor    %eax,%eax
}
80102912:	c3                   	ret    
80102913:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010291a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102920 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102920:	a1 80 36 11 80       	mov    0x80113680,%eax
80102925:	85 c0                	test   %eax,%eax
80102927:	74 0d                	je     80102936 <lapiceoi+0x16>
  lapic[index] = value;
80102929:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102930:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102933:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102936:	c3                   	ret    
80102937:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010293e:	66 90                	xchg   %ax,%ax

80102940 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102940:	c3                   	ret    
80102941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102948:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010294f:	90                   	nop

80102950 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102950:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102951:	b8 0f 00 00 00       	mov    $0xf,%eax
80102956:	ba 70 00 00 00       	mov    $0x70,%edx
8010295b:	89 e5                	mov    %esp,%ebp
8010295d:	53                   	push   %ebx
8010295e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102961:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102964:	ee                   	out    %al,(%dx)
80102965:	b8 0a 00 00 00       	mov    $0xa,%eax
8010296a:	ba 71 00 00 00       	mov    $0x71,%edx
8010296f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102970:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102972:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102975:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010297b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010297d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102980:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102982:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102985:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102988:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010298e:	a1 80 36 11 80       	mov    0x80113680,%eax
80102993:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102999:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010299c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801029a3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029a9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029b0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029b3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029b6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029bc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029bf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029c5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029c8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029ce:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029d1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029d7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029dd:	c9                   	leave  
801029de:	c3                   	ret    
801029df:	90                   	nop

801029e0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029e0:	55                   	push   %ebp
801029e1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029e6:	ba 70 00 00 00       	mov    $0x70,%edx
801029eb:	89 e5                	mov    %esp,%ebp
801029ed:	57                   	push   %edi
801029ee:	56                   	push   %esi
801029ef:	53                   	push   %ebx
801029f0:	83 ec 4c             	sub    $0x4c,%esp
801029f3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f4:	ba 71 00 00 00       	mov    $0x71,%edx
801029f9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029fa:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029fd:	bb 70 00 00 00       	mov    $0x70,%ebx
80102a02:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a05:	8d 76 00             	lea    0x0(%esi),%esi
80102a08:	31 c0                	xor    %eax,%eax
80102a0a:	89 da                	mov    %ebx,%edx
80102a0c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a0d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a12:	89 ca                	mov    %ecx,%edx
80102a14:	ec                   	in     (%dx),%al
80102a15:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a18:	89 da                	mov    %ebx,%edx
80102a1a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a1f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a20:	89 ca                	mov    %ecx,%edx
80102a22:	ec                   	in     (%dx),%al
80102a23:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a26:	89 da                	mov    %ebx,%edx
80102a28:	b8 04 00 00 00       	mov    $0x4,%eax
80102a2d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2e:	89 ca                	mov    %ecx,%edx
80102a30:	ec                   	in     (%dx),%al
80102a31:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a34:	89 da                	mov    %ebx,%edx
80102a36:	b8 07 00 00 00       	mov    $0x7,%eax
80102a3b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a3c:	89 ca                	mov    %ecx,%edx
80102a3e:	ec                   	in     (%dx),%al
80102a3f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a42:	89 da                	mov    %ebx,%edx
80102a44:	b8 08 00 00 00       	mov    $0x8,%eax
80102a49:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a4a:	89 ca                	mov    %ecx,%edx
80102a4c:	ec                   	in     (%dx),%al
80102a4d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a4f:	89 da                	mov    %ebx,%edx
80102a51:	b8 09 00 00 00       	mov    $0x9,%eax
80102a56:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a57:	89 ca                	mov    %ecx,%edx
80102a59:	ec                   	in     (%dx),%al
80102a5a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a5c:	89 da                	mov    %ebx,%edx
80102a5e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a63:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a64:	89 ca                	mov    %ecx,%edx
80102a66:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a67:	84 c0                	test   %al,%al
80102a69:	78 9d                	js     80102a08 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a6b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a6f:	89 fa                	mov    %edi,%edx
80102a71:	0f b6 fa             	movzbl %dl,%edi
80102a74:	89 f2                	mov    %esi,%edx
80102a76:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a79:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a7d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a80:	89 da                	mov    %ebx,%edx
80102a82:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a85:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a88:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a8c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a8f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a92:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a96:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a99:	31 c0                	xor    %eax,%eax
80102a9b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9c:	89 ca                	mov    %ecx,%edx
80102a9e:	ec                   	in     (%dx),%al
80102a9f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa2:	89 da                	mov    %ebx,%edx
80102aa4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102aa7:	b8 02 00 00 00       	mov    $0x2,%eax
80102aac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aad:	89 ca                	mov    %ecx,%edx
80102aaf:	ec                   	in     (%dx),%al
80102ab0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab3:	89 da                	mov    %ebx,%edx
80102ab5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102ab8:	b8 04 00 00 00       	mov    $0x4,%eax
80102abd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abe:	89 ca                	mov    %ecx,%edx
80102ac0:	ec                   	in     (%dx),%al
80102ac1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac4:	89 da                	mov    %ebx,%edx
80102ac6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ac9:	b8 07 00 00 00       	mov    $0x7,%eax
80102ace:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102acf:	89 ca                	mov    %ecx,%edx
80102ad1:	ec                   	in     (%dx),%al
80102ad2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad5:	89 da                	mov    %ebx,%edx
80102ad7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102ada:	b8 08 00 00 00       	mov    $0x8,%eax
80102adf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae0:	89 ca                	mov    %ecx,%edx
80102ae2:	ec                   	in     (%dx),%al
80102ae3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae6:	89 da                	mov    %ebx,%edx
80102ae8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102aeb:	b8 09 00 00 00       	mov    $0x9,%eax
80102af0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102af1:	89 ca                	mov    %ecx,%edx
80102af3:	ec                   	in     (%dx),%al
80102af4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102af7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102afa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102afd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b00:	6a 18                	push   $0x18
80102b02:	50                   	push   %eax
80102b03:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b06:	50                   	push   %eax
80102b07:	e8 e4 1c 00 00       	call   801047f0 <memcmp>
80102b0c:	83 c4 10             	add    $0x10,%esp
80102b0f:	85 c0                	test   %eax,%eax
80102b11:	0f 85 f1 fe ff ff    	jne    80102a08 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b17:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b1b:	75 78                	jne    80102b95 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b1d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b20:	89 c2                	mov    %eax,%edx
80102b22:	83 e0 0f             	and    $0xf,%eax
80102b25:	c1 ea 04             	shr    $0x4,%edx
80102b28:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b2e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b31:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b34:	89 c2                	mov    %eax,%edx
80102b36:	83 e0 0f             	and    $0xf,%eax
80102b39:	c1 ea 04             	shr    $0x4,%edx
80102b3c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b3f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b42:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b45:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b48:	89 c2                	mov    %eax,%edx
80102b4a:	83 e0 0f             	and    $0xf,%eax
80102b4d:	c1 ea 04             	shr    $0x4,%edx
80102b50:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b53:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b56:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b59:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b5c:	89 c2                	mov    %eax,%edx
80102b5e:	83 e0 0f             	and    $0xf,%eax
80102b61:	c1 ea 04             	shr    $0x4,%edx
80102b64:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b67:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b6a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b6d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b70:	89 c2                	mov    %eax,%edx
80102b72:	83 e0 0f             	and    $0xf,%eax
80102b75:	c1 ea 04             	shr    $0x4,%edx
80102b78:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b7b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b7e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b81:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b84:	89 c2                	mov    %eax,%edx
80102b86:	83 e0 0f             	and    $0xf,%eax
80102b89:	c1 ea 04             	shr    $0x4,%edx
80102b8c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b8f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b92:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b95:	8b 75 08             	mov    0x8(%ebp),%esi
80102b98:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b9b:	89 06                	mov    %eax,(%esi)
80102b9d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ba0:	89 46 04             	mov    %eax,0x4(%esi)
80102ba3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ba6:	89 46 08             	mov    %eax,0x8(%esi)
80102ba9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bac:	89 46 0c             	mov    %eax,0xc(%esi)
80102baf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bb2:	89 46 10             	mov    %eax,0x10(%esi)
80102bb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bb8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102bbb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102bc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bc5:	5b                   	pop    %ebx
80102bc6:	5e                   	pop    %esi
80102bc7:	5f                   	pop    %edi
80102bc8:	5d                   	pop    %ebp
80102bc9:	c3                   	ret    
80102bca:	66 90                	xchg   %ax,%ax
80102bcc:	66 90                	xchg   %ax,%ax
80102bce:	66 90                	xchg   %ax,%ax

80102bd0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bd0:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102bd6:	85 c9                	test   %ecx,%ecx
80102bd8:	0f 8e 8a 00 00 00    	jle    80102c68 <install_trans+0x98>
{
80102bde:	55                   	push   %ebp
80102bdf:	89 e5                	mov    %esp,%ebp
80102be1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102be2:	31 ff                	xor    %edi,%edi
{
80102be4:	56                   	push   %esi
80102be5:	53                   	push   %ebx
80102be6:	83 ec 0c             	sub    $0xc,%esp
80102be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bf0:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102bf5:	83 ec 08             	sub    $0x8,%esp
80102bf8:	01 f8                	add    %edi,%eax
80102bfa:	83 c0 01             	add    $0x1,%eax
80102bfd:	50                   	push   %eax
80102bfe:	ff 35 e4 36 11 80    	push   0x801136e4
80102c04:	e8 c7 d4 ff ff       	call   801000d0 <bread>
80102c09:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c0b:	58                   	pop    %eax
80102c0c:	5a                   	pop    %edx
80102c0d:	ff 34 bd ec 36 11 80 	push   -0x7feec914(,%edi,4)
80102c14:	ff 35 e4 36 11 80    	push   0x801136e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c1a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c1d:	e8 ae d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c22:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c25:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c27:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c2a:	68 00 02 00 00       	push   $0x200
80102c2f:	50                   	push   %eax
80102c30:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c33:	50                   	push   %eax
80102c34:	e8 07 1c 00 00       	call   80104840 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c39:	89 1c 24             	mov    %ebx,(%esp)
80102c3c:	e8 6f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c41:	89 34 24             	mov    %esi,(%esp)
80102c44:	e8 a7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c49:	89 1c 24             	mov    %ebx,(%esp)
80102c4c:	e8 9f d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c51:	83 c4 10             	add    $0x10,%esp
80102c54:	39 3d e8 36 11 80    	cmp    %edi,0x801136e8
80102c5a:	7f 94                	jg     80102bf0 <install_trans+0x20>
  }
}
80102c5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c5f:	5b                   	pop    %ebx
80102c60:	5e                   	pop    %esi
80102c61:	5f                   	pop    %edi
80102c62:	5d                   	pop    %ebp
80102c63:	c3                   	ret    
80102c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c68:	c3                   	ret    
80102c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c70 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c70:	55                   	push   %ebp
80102c71:	89 e5                	mov    %esp,%ebp
80102c73:	53                   	push   %ebx
80102c74:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c77:	ff 35 d4 36 11 80    	push   0x801136d4
80102c7d:	ff 35 e4 36 11 80    	push   0x801136e4
80102c83:	e8 48 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c88:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c8b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c8d:	a1 e8 36 11 80       	mov    0x801136e8,%eax
80102c92:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c95:	85 c0                	test   %eax,%eax
80102c97:	7e 19                	jle    80102cb2 <write_head+0x42>
80102c99:	31 d2                	xor    %edx,%edx
80102c9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c9f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102ca0:	8b 0c 95 ec 36 11 80 	mov    -0x7feec914(,%edx,4),%ecx
80102ca7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102cab:	83 c2 01             	add    $0x1,%edx
80102cae:	39 d0                	cmp    %edx,%eax
80102cb0:	75 ee                	jne    80102ca0 <write_head+0x30>
  }
  bwrite(buf);
80102cb2:	83 ec 0c             	sub    $0xc,%esp
80102cb5:	53                   	push   %ebx
80102cb6:	e8 f5 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102cbb:	89 1c 24             	mov    %ebx,(%esp)
80102cbe:	e8 2d d5 ff ff       	call   801001f0 <brelse>
}
80102cc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cc6:	83 c4 10             	add    $0x10,%esp
80102cc9:	c9                   	leave  
80102cca:	c3                   	ret    
80102ccb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ccf:	90                   	nop

80102cd0 <initlog>:
{
80102cd0:	55                   	push   %ebp
80102cd1:	89 e5                	mov    %esp,%ebp
80102cd3:	53                   	push   %ebx
80102cd4:	83 ec 2c             	sub    $0x2c,%esp
80102cd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cda:	68 20 8b 10 80       	push   $0x80108b20
80102cdf:	68 a0 36 11 80       	push   $0x801136a0
80102ce4:	e8 27 18 00 00       	call   80104510 <initlock>
  readsb(dev, &sb);
80102ce9:	58                   	pop    %eax
80102cea:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102ced:	5a                   	pop    %edx
80102cee:	50                   	push   %eax
80102cef:	53                   	push   %ebx
80102cf0:	e8 3b e8 ff ff       	call   80101530 <readsb>
  log.start = sb.logstart;
80102cf5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102cf8:	59                   	pop    %ecx
  log.dev = dev;
80102cf9:	89 1d e4 36 11 80    	mov    %ebx,0x801136e4
  log.size = sb.nlog;
80102cff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d02:	a3 d4 36 11 80       	mov    %eax,0x801136d4
  log.size = sb.nlog;
80102d07:	89 15 d8 36 11 80    	mov    %edx,0x801136d8
  struct buf *buf = bread(log.dev, log.start);
80102d0d:	5a                   	pop    %edx
80102d0e:	50                   	push   %eax
80102d0f:	53                   	push   %ebx
80102d10:	e8 bb d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d15:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d18:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d1b:	89 1d e8 36 11 80    	mov    %ebx,0x801136e8
  for (i = 0; i < log.lh.n; i++) {
80102d21:	85 db                	test   %ebx,%ebx
80102d23:	7e 1d                	jle    80102d42 <initlog+0x72>
80102d25:	31 d2                	xor    %edx,%edx
80102d27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d2e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102d30:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d34:	89 0c 95 ec 36 11 80 	mov    %ecx,-0x7feec914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d3b:	83 c2 01             	add    $0x1,%edx
80102d3e:	39 d3                	cmp    %edx,%ebx
80102d40:	75 ee                	jne    80102d30 <initlog+0x60>
  brelse(buf);
80102d42:	83 ec 0c             	sub    $0xc,%esp
80102d45:	50                   	push   %eax
80102d46:	e8 a5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d4b:	e8 80 fe ff ff       	call   80102bd0 <install_trans>
  log.lh.n = 0;
80102d50:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80102d57:	00 00 00 
  write_head(); // clear the log
80102d5a:	e8 11 ff ff ff       	call   80102c70 <write_head>
}
80102d5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d62:	83 c4 10             	add    $0x10,%esp
80102d65:	c9                   	leave  
80102d66:	c3                   	ret    
80102d67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d6e:	66 90                	xchg   %ax,%ax

80102d70 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d76:	68 a0 36 11 80       	push   $0x801136a0
80102d7b:	e8 60 19 00 00       	call   801046e0 <acquire>
80102d80:	83 c4 10             	add    $0x10,%esp
80102d83:	eb 18                	jmp    80102d9d <begin_op+0x2d>
80102d85:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d88:	83 ec 08             	sub    $0x8,%esp
80102d8b:	68 a0 36 11 80       	push   $0x801136a0
80102d90:	68 a0 36 11 80       	push   $0x801136a0
80102d95:	e8 e6 13 00 00       	call   80104180 <sleep>
80102d9a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d9d:	a1 e0 36 11 80       	mov    0x801136e0,%eax
80102da2:	85 c0                	test   %eax,%eax
80102da4:	75 e2                	jne    80102d88 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102da6:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102dab:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
80102db1:	83 c0 01             	add    $0x1,%eax
80102db4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102db7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102dba:	83 fa 1e             	cmp    $0x1e,%edx
80102dbd:	7f c9                	jg     80102d88 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102dbf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102dc2:	a3 dc 36 11 80       	mov    %eax,0x801136dc
      release(&log.lock);
80102dc7:	68 a0 36 11 80       	push   $0x801136a0
80102dcc:	e8 af 18 00 00       	call   80104680 <release>
      break;
    }
  }
}
80102dd1:	83 c4 10             	add    $0x10,%esp
80102dd4:	c9                   	leave  
80102dd5:	c3                   	ret    
80102dd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ddd:	8d 76 00             	lea    0x0(%esi),%esi

80102de0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102de0:	55                   	push   %ebp
80102de1:	89 e5                	mov    %esp,%ebp
80102de3:	57                   	push   %edi
80102de4:	56                   	push   %esi
80102de5:	53                   	push   %ebx
80102de6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102de9:	68 a0 36 11 80       	push   $0x801136a0
80102dee:	e8 ed 18 00 00       	call   801046e0 <acquire>
  log.outstanding -= 1;
80102df3:	a1 dc 36 11 80       	mov    0x801136dc,%eax
  if(log.committing)
80102df8:	8b 35 e0 36 11 80    	mov    0x801136e0,%esi
80102dfe:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e01:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102e04:	89 1d dc 36 11 80    	mov    %ebx,0x801136dc
  if(log.committing)
80102e0a:	85 f6                	test   %esi,%esi
80102e0c:	0f 85 22 01 00 00    	jne    80102f34 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e12:	85 db                	test   %ebx,%ebx
80102e14:	0f 85 f6 00 00 00    	jne    80102f10 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e1a:	c7 05 e0 36 11 80 01 	movl   $0x1,0x801136e0
80102e21:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e24:	83 ec 0c             	sub    $0xc,%esp
80102e27:	68 a0 36 11 80       	push   $0x801136a0
80102e2c:	e8 4f 18 00 00       	call   80104680 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e31:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102e37:	83 c4 10             	add    $0x10,%esp
80102e3a:	85 c9                	test   %ecx,%ecx
80102e3c:	7f 42                	jg     80102e80 <end_op+0xa0>
    acquire(&log.lock);
80102e3e:	83 ec 0c             	sub    $0xc,%esp
80102e41:	68 a0 36 11 80       	push   $0x801136a0
80102e46:	e8 95 18 00 00       	call   801046e0 <acquire>
    wakeup(&log);
80102e4b:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
    log.committing = 0;
80102e52:	c7 05 e0 36 11 80 00 	movl   $0x0,0x801136e0
80102e59:	00 00 00 
    wakeup(&log);
80102e5c:	e8 df 13 00 00       	call   80104240 <wakeup>
    release(&log.lock);
80102e61:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102e68:	e8 13 18 00 00       	call   80104680 <release>
80102e6d:	83 c4 10             	add    $0x10,%esp
}
80102e70:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e73:	5b                   	pop    %ebx
80102e74:	5e                   	pop    %esi
80102e75:	5f                   	pop    %edi
80102e76:	5d                   	pop    %ebp
80102e77:	c3                   	ret    
80102e78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e7f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e80:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102e85:	83 ec 08             	sub    $0x8,%esp
80102e88:	01 d8                	add    %ebx,%eax
80102e8a:	83 c0 01             	add    $0x1,%eax
80102e8d:	50                   	push   %eax
80102e8e:	ff 35 e4 36 11 80    	push   0x801136e4
80102e94:	e8 37 d2 ff ff       	call   801000d0 <bread>
80102e99:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e9b:	58                   	pop    %eax
80102e9c:	5a                   	pop    %edx
80102e9d:	ff 34 9d ec 36 11 80 	push   -0x7feec914(,%ebx,4)
80102ea4:	ff 35 e4 36 11 80    	push   0x801136e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102eaa:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ead:	e8 1e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102eb2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102eb5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102eb7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102eba:	68 00 02 00 00       	push   $0x200
80102ebf:	50                   	push   %eax
80102ec0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ec3:	50                   	push   %eax
80102ec4:	e8 77 19 00 00       	call   80104840 <memmove>
    bwrite(to);  // write the log
80102ec9:	89 34 24             	mov    %esi,(%esp)
80102ecc:	e8 df d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ed1:	89 3c 24             	mov    %edi,(%esp)
80102ed4:	e8 17 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ed9:	89 34 24             	mov    %esi,(%esp)
80102edc:	e8 0f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ee1:	83 c4 10             	add    $0x10,%esp
80102ee4:	3b 1d e8 36 11 80    	cmp    0x801136e8,%ebx
80102eea:	7c 94                	jl     80102e80 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102eec:	e8 7f fd ff ff       	call   80102c70 <write_head>
    install_trans(); // Now install writes to home locations
80102ef1:	e8 da fc ff ff       	call   80102bd0 <install_trans>
    log.lh.n = 0;
80102ef6:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80102efd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f00:	e8 6b fd ff ff       	call   80102c70 <write_head>
80102f05:	e9 34 ff ff ff       	jmp    80102e3e <end_op+0x5e>
80102f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f10:	83 ec 0c             	sub    $0xc,%esp
80102f13:	68 a0 36 11 80       	push   $0x801136a0
80102f18:	e8 23 13 00 00       	call   80104240 <wakeup>
  release(&log.lock);
80102f1d:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102f24:	e8 57 17 00 00       	call   80104680 <release>
80102f29:	83 c4 10             	add    $0x10,%esp
}
80102f2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f2f:	5b                   	pop    %ebx
80102f30:	5e                   	pop    %esi
80102f31:	5f                   	pop    %edi
80102f32:	5d                   	pop    %ebp
80102f33:	c3                   	ret    
    panic("log.committing");
80102f34:	83 ec 0c             	sub    $0xc,%esp
80102f37:	68 24 8b 10 80       	push   $0x80108b24
80102f3c:	e8 3f d4 ff ff       	call   80100380 <panic>
80102f41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f4f:	90                   	nop

80102f50 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f50:	55                   	push   %ebp
80102f51:	89 e5                	mov    %esp,%ebp
80102f53:	53                   	push   %ebx
80102f54:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f57:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
{
80102f5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f60:	83 fa 1d             	cmp    $0x1d,%edx
80102f63:	0f 8f 85 00 00 00    	jg     80102fee <log_write+0x9e>
80102f69:	a1 d8 36 11 80       	mov    0x801136d8,%eax
80102f6e:	83 e8 01             	sub    $0x1,%eax
80102f71:	39 c2                	cmp    %eax,%edx
80102f73:	7d 79                	jge    80102fee <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f75:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102f7a:	85 c0                	test   %eax,%eax
80102f7c:	7e 7d                	jle    80102ffb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f7e:	83 ec 0c             	sub    $0xc,%esp
80102f81:	68 a0 36 11 80       	push   $0x801136a0
80102f86:	e8 55 17 00 00       	call   801046e0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f8b:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
80102f91:	83 c4 10             	add    $0x10,%esp
80102f94:	85 d2                	test   %edx,%edx
80102f96:	7e 4a                	jle    80102fe2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f98:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f9b:	31 c0                	xor    %eax,%eax
80102f9d:	eb 08                	jmp    80102fa7 <log_write+0x57>
80102f9f:	90                   	nop
80102fa0:	83 c0 01             	add    $0x1,%eax
80102fa3:	39 c2                	cmp    %eax,%edx
80102fa5:	74 29                	je     80102fd0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fa7:	39 0c 85 ec 36 11 80 	cmp    %ecx,-0x7feec914(,%eax,4)
80102fae:	75 f0                	jne    80102fa0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fb0:	89 0c 85 ec 36 11 80 	mov    %ecx,-0x7feec914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fb7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102fba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fbd:	c7 45 08 a0 36 11 80 	movl   $0x801136a0,0x8(%ebp)
}
80102fc4:	c9                   	leave  
  release(&log.lock);
80102fc5:	e9 b6 16 00 00       	jmp    80104680 <release>
80102fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fd0:	89 0c 95 ec 36 11 80 	mov    %ecx,-0x7feec914(,%edx,4)
    log.lh.n++;
80102fd7:	83 c2 01             	add    $0x1,%edx
80102fda:	89 15 e8 36 11 80    	mov    %edx,0x801136e8
80102fe0:	eb d5                	jmp    80102fb7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80102fe2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fe5:	a3 ec 36 11 80       	mov    %eax,0x801136ec
  if (i == log.lh.n)
80102fea:	75 cb                	jne    80102fb7 <log_write+0x67>
80102fec:	eb e9                	jmp    80102fd7 <log_write+0x87>
    panic("too big a transaction");
80102fee:	83 ec 0c             	sub    $0xc,%esp
80102ff1:	68 33 8b 10 80       	push   $0x80108b33
80102ff6:	e8 85 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102ffb:	83 ec 0c             	sub    $0xc,%esp
80102ffe:	68 49 8b 10 80       	push   $0x80108b49
80103003:	e8 78 d3 ff ff       	call   80100380 <panic>
80103008:	66 90                	xchg   %ax,%ax
8010300a:	66 90                	xchg   %ax,%ax
8010300c:	66 90                	xchg   %ax,%ax
8010300e:	66 90                	xchg   %ax,%ax

80103010 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103010:	55                   	push   %ebp
80103011:	89 e5                	mov    %esp,%ebp
80103013:	53                   	push   %ebx
80103014:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103017:	e8 a4 09 00 00       	call   801039c0 <cpuid>
8010301c:	89 c3                	mov    %eax,%ebx
8010301e:	e8 9d 09 00 00       	call   801039c0 <cpuid>
80103023:	83 ec 04             	sub    $0x4,%esp
80103026:	53                   	push   %ebx
80103027:	50                   	push   %eax
80103028:	68 64 8b 10 80       	push   $0x80108b64
8010302d:	e8 6e d6 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103032:	e8 19 2c 00 00       	call   80105c50 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103037:	e8 24 09 00 00       	call   80103960 <mycpu>
8010303c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010303e:	b8 01 00 00 00       	mov    $0x1,%eax
80103043:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010304a:	e8 b1 0c 00 00       	call   80103d00 <scheduler>
8010304f:	90                   	nop

80103050 <mpenter>:
{
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103056:	e8 95 3e 00 00       	call   80106ef0 <switchkvm>
  seginit();
8010305b:	e8 00 3e 00 00       	call   80106e60 <seginit>
  lapicinit();
80103060:	e8 9b f7 ff ff       	call   80102800 <lapicinit>
  mpmain();
80103065:	e8 a6 ff ff ff       	call   80103010 <mpmain>
8010306a:	66 90                	xchg   %ax,%ax
8010306c:	66 90                	xchg   %ax,%ax
8010306e:	66 90                	xchg   %ax,%ax

80103070 <main>:
{
80103070:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103074:	83 e4 f0             	and    $0xfffffff0,%esp
80103077:	ff 71 fc             	push   -0x4(%ecx)
8010307a:	55                   	push   %ebp
8010307b:	89 e5                	mov    %esp,%ebp
8010307d:	53                   	push   %ebx
8010307e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010307f:	83 ec 08             	sub    $0x8,%esp
80103082:	68 00 00 40 80       	push   $0x80400000
80103087:	68 40 c6 21 80       	push   $0x8021c640
8010308c:	e8 8f f5 ff ff       	call   80102620 <kinit1>
  kvmalloc();      // kernel page table
80103091:	e8 ea 43 00 00       	call   80107480 <kvmalloc>
  mpinit();        // detect other processors
80103096:	e8 85 01 00 00       	call   80103220 <mpinit>
  lapicinit();     // interrupt controller
8010309b:	e8 60 f7 ff ff       	call   80102800 <lapicinit>
  seginit();       // segment descriptors
801030a0:	e8 bb 3d 00 00       	call   80106e60 <seginit>
  picinit();       // disable pic
801030a5:	e8 76 03 00 00       	call   80103420 <picinit>
  ioapicinit();    // another interrupt controller
801030aa:	e8 31 f3 ff ff       	call   801023e0 <ioapicinit>
  consoleinit();   // console hardware
801030af:	e8 ac d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801030b4:	e8 c7 2f 00 00       	call   80106080 <uartinit>
  pinit();         // process table
801030b9:	e8 82 08 00 00       	call   80103940 <pinit>
  tvinit();        // trap vectors
801030be:	e8 0d 2b 00 00       	call   80105bd0 <tvinit>
  binit();         // buffer cache
801030c3:	e8 78 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030c8:	e8 53 dd ff ff       	call   80100e20 <fileinit>
  ideinit();       // disk 
801030cd:	e8 fe f0 ff ff       	call   801021d0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030d2:	83 c4 0c             	add    $0xc,%esp
801030d5:	68 8a 00 00 00       	push   $0x8a
801030da:	68 8c c4 10 80       	push   $0x8010c48c
801030df:	68 00 70 00 80       	push   $0x80007000
801030e4:	e8 57 17 00 00       	call   80104840 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030e9:	83 c4 10             	add    $0x10,%esp
801030ec:	69 05 a4 37 21 80 b0 	imul   $0xb0,0x802137a4,%eax
801030f3:	00 00 00 
801030f6:	05 c0 37 21 80       	add    $0x802137c0,%eax
801030fb:	3d c0 37 21 80       	cmp    $0x802137c0,%eax
80103100:	76 7e                	jbe    80103180 <main+0x110>
80103102:	bb c0 37 21 80       	mov    $0x802137c0,%ebx
80103107:	eb 20                	jmp    80103129 <main+0xb9>
80103109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103110:	69 05 a4 37 21 80 b0 	imul   $0xb0,0x802137a4,%eax
80103117:	00 00 00 
8010311a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103120:	05 c0 37 21 80       	add    $0x802137c0,%eax
80103125:	39 c3                	cmp    %eax,%ebx
80103127:	73 57                	jae    80103180 <main+0x110>
    if(c == mycpu())  // We've started already.
80103129:	e8 32 08 00 00       	call   80103960 <mycpu>
8010312e:	39 c3                	cmp    %eax,%ebx
80103130:	74 de                	je     80103110 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103132:	e8 59 f5 ff ff       	call   80102690 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103137:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010313a:	c7 05 f8 6f 00 80 50 	movl   $0x80103050,0x80006ff8
80103141:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103144:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
8010314b:	b0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010314e:	05 00 10 00 00       	add    $0x1000,%eax
80103153:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103158:	0f b6 03             	movzbl (%ebx),%eax
8010315b:	68 00 70 00 00       	push   $0x7000
80103160:	50                   	push   %eax
80103161:	e8 ea f7 ff ff       	call   80102950 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103166:	83 c4 10             	add    $0x10,%esp
80103169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103170:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103176:	85 c0                	test   %eax,%eax
80103178:	74 f6                	je     80103170 <main+0x100>
8010317a:	eb 94                	jmp    80103110 <main+0xa0>
8010317c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103180:	83 ec 08             	sub    $0x8,%esp
80103183:	68 00 00 00 8e       	push   $0x8e000000
80103188:	68 00 00 40 80       	push   $0x80400000
8010318d:	e8 2e f4 ff ff       	call   801025c0 <kinit2>
  userinit();      // first user process
80103192:	e8 79 08 00 00       	call   80103a10 <userinit>
  mpmain();        // finish this processor's setup
80103197:	e8 74 fe ff ff       	call   80103010 <mpmain>
8010319c:	66 90                	xchg   %ax,%ax
8010319e:	66 90                	xchg   %ax,%ax

801031a0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031a0:	55                   	push   %ebp
801031a1:	89 e5                	mov    %esp,%ebp
801031a3:	57                   	push   %edi
801031a4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801031a5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801031ab:	53                   	push   %ebx
  e = addr+len;
801031ac:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801031af:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031b2:	39 de                	cmp    %ebx,%esi
801031b4:	72 10                	jb     801031c6 <mpsearch1+0x26>
801031b6:	eb 50                	jmp    80103208 <mpsearch1+0x68>
801031b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031bf:	90                   	nop
801031c0:	89 fe                	mov    %edi,%esi
801031c2:	39 fb                	cmp    %edi,%ebx
801031c4:	76 42                	jbe    80103208 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031c6:	83 ec 04             	sub    $0x4,%esp
801031c9:	8d 7e 10             	lea    0x10(%esi),%edi
801031cc:	6a 04                	push   $0x4
801031ce:	68 78 8b 10 80       	push   $0x80108b78
801031d3:	56                   	push   %esi
801031d4:	e8 17 16 00 00       	call   801047f0 <memcmp>
801031d9:	83 c4 10             	add    $0x10,%esp
801031dc:	85 c0                	test   %eax,%eax
801031de:	75 e0                	jne    801031c0 <mpsearch1+0x20>
801031e0:	89 f2                	mov    %esi,%edx
801031e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031e8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801031eb:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801031ee:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031f0:	39 fa                	cmp    %edi,%edx
801031f2:	75 f4                	jne    801031e8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031f4:	84 c0                	test   %al,%al
801031f6:	75 c8                	jne    801031c0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031fb:	89 f0                	mov    %esi,%eax
801031fd:	5b                   	pop    %ebx
801031fe:	5e                   	pop    %esi
801031ff:	5f                   	pop    %edi
80103200:	5d                   	pop    %ebp
80103201:	c3                   	ret    
80103202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103208:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010320b:	31 f6                	xor    %esi,%esi
}
8010320d:	5b                   	pop    %ebx
8010320e:	89 f0                	mov    %esi,%eax
80103210:	5e                   	pop    %esi
80103211:	5f                   	pop    %edi
80103212:	5d                   	pop    %ebp
80103213:	c3                   	ret    
80103214:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010321b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010321f:	90                   	nop

80103220 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103220:	55                   	push   %ebp
80103221:	89 e5                	mov    %esp,%ebp
80103223:	57                   	push   %edi
80103224:	56                   	push   %esi
80103225:	53                   	push   %ebx
80103226:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103229:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103230:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103237:	c1 e0 08             	shl    $0x8,%eax
8010323a:	09 d0                	or     %edx,%eax
8010323c:	c1 e0 04             	shl    $0x4,%eax
8010323f:	75 1b                	jne    8010325c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103241:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103248:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010324f:	c1 e0 08             	shl    $0x8,%eax
80103252:	09 d0                	or     %edx,%eax
80103254:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103257:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010325c:	ba 00 04 00 00       	mov    $0x400,%edx
80103261:	e8 3a ff ff ff       	call   801031a0 <mpsearch1>
80103266:	89 c3                	mov    %eax,%ebx
80103268:	85 c0                	test   %eax,%eax
8010326a:	0f 84 40 01 00 00    	je     801033b0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103270:	8b 73 04             	mov    0x4(%ebx),%esi
80103273:	85 f6                	test   %esi,%esi
80103275:	0f 84 25 01 00 00    	je     801033a0 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010327b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010327e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103284:	6a 04                	push   $0x4
80103286:	68 7d 8b 10 80       	push   $0x80108b7d
8010328b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010328c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010328f:	e8 5c 15 00 00       	call   801047f0 <memcmp>
80103294:	83 c4 10             	add    $0x10,%esp
80103297:	85 c0                	test   %eax,%eax
80103299:	0f 85 01 01 00 00    	jne    801033a0 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010329f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801032a6:	3c 01                	cmp    $0x1,%al
801032a8:	74 08                	je     801032b2 <mpinit+0x92>
801032aa:	3c 04                	cmp    $0x4,%al
801032ac:	0f 85 ee 00 00 00    	jne    801033a0 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801032b2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801032b9:	66 85 d2             	test   %dx,%dx
801032bc:	74 22                	je     801032e0 <mpinit+0xc0>
801032be:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801032c1:	89 f0                	mov    %esi,%eax
  sum = 0;
801032c3:	31 d2                	xor    %edx,%edx
801032c5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801032c8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801032cf:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801032d2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032d4:	39 c7                	cmp    %eax,%edi
801032d6:	75 f0                	jne    801032c8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801032d8:	84 d2                	test   %dl,%dl
801032da:	0f 85 c0 00 00 00    	jne    801033a0 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032e0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801032e6:	a3 80 36 11 80       	mov    %eax,0x80113680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032eb:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801032f2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801032f8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032fd:	03 55 e4             	add    -0x1c(%ebp),%edx
80103300:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103303:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103307:	90                   	nop
80103308:	39 d0                	cmp    %edx,%eax
8010330a:	73 15                	jae    80103321 <mpinit+0x101>
    switch(*p){
8010330c:	0f b6 08             	movzbl (%eax),%ecx
8010330f:	80 f9 02             	cmp    $0x2,%cl
80103312:	74 4c                	je     80103360 <mpinit+0x140>
80103314:	77 3a                	ja     80103350 <mpinit+0x130>
80103316:	84 c9                	test   %cl,%cl
80103318:	74 56                	je     80103370 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010331a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010331d:	39 d0                	cmp    %edx,%eax
8010331f:	72 eb                	jb     8010330c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103321:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103324:	85 f6                	test   %esi,%esi
80103326:	0f 84 d9 00 00 00    	je     80103405 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010332c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103330:	74 15                	je     80103347 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103332:	b8 70 00 00 00       	mov    $0x70,%eax
80103337:	ba 22 00 00 00       	mov    $0x22,%edx
8010333c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010333d:	ba 23 00 00 00       	mov    $0x23,%edx
80103342:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103343:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103346:	ee                   	out    %al,(%dx)
  }
}
80103347:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010334a:	5b                   	pop    %ebx
8010334b:	5e                   	pop    %esi
8010334c:	5f                   	pop    %edi
8010334d:	5d                   	pop    %ebp
8010334e:	c3                   	ret    
8010334f:	90                   	nop
    switch(*p){
80103350:	83 e9 03             	sub    $0x3,%ecx
80103353:	80 f9 01             	cmp    $0x1,%cl
80103356:	76 c2                	jbe    8010331a <mpinit+0xfa>
80103358:	31 f6                	xor    %esi,%esi
8010335a:	eb ac                	jmp    80103308 <mpinit+0xe8>
8010335c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103360:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103364:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103367:	88 0d a0 37 21 80    	mov    %cl,0x802137a0
      continue;
8010336d:	eb 99                	jmp    80103308 <mpinit+0xe8>
8010336f:	90                   	nop
      if(ncpu < NCPU) {
80103370:	8b 0d a4 37 21 80    	mov    0x802137a4,%ecx
80103376:	83 f9 07             	cmp    $0x7,%ecx
80103379:	7f 19                	jg     80103394 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103381:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103385:	83 c1 01             	add    $0x1,%ecx
80103388:	89 0d a4 37 21 80    	mov    %ecx,0x802137a4
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010338e:	88 9f c0 37 21 80    	mov    %bl,-0x7fdec840(%edi)
      p += sizeof(struct mpproc);
80103394:	83 c0 14             	add    $0x14,%eax
      continue;
80103397:	e9 6c ff ff ff       	jmp    80103308 <mpinit+0xe8>
8010339c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801033a0:	83 ec 0c             	sub    $0xc,%esp
801033a3:	68 82 8b 10 80       	push   $0x80108b82
801033a8:	e8 d3 cf ff ff       	call   80100380 <panic>
801033ad:	8d 76 00             	lea    0x0(%esi),%esi
{
801033b0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801033b5:	eb 13                	jmp    801033ca <mpinit+0x1aa>
801033b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033be:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801033c0:	89 f3                	mov    %esi,%ebx
801033c2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801033c8:	74 d6                	je     801033a0 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033ca:	83 ec 04             	sub    $0x4,%esp
801033cd:	8d 73 10             	lea    0x10(%ebx),%esi
801033d0:	6a 04                	push   $0x4
801033d2:	68 78 8b 10 80       	push   $0x80108b78
801033d7:	53                   	push   %ebx
801033d8:	e8 13 14 00 00       	call   801047f0 <memcmp>
801033dd:	83 c4 10             	add    $0x10,%esp
801033e0:	85 c0                	test   %eax,%eax
801033e2:	75 dc                	jne    801033c0 <mpinit+0x1a0>
801033e4:	89 da                	mov    %ebx,%edx
801033e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033ed:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801033f0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801033f3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801033f6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033f8:	39 d6                	cmp    %edx,%esi
801033fa:	75 f4                	jne    801033f0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033fc:	84 c0                	test   %al,%al
801033fe:	75 c0                	jne    801033c0 <mpinit+0x1a0>
80103400:	e9 6b fe ff ff       	jmp    80103270 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103405:	83 ec 0c             	sub    $0xc,%esp
80103408:	68 9c 8b 10 80       	push   $0x80108b9c
8010340d:	e8 6e cf ff ff       	call   80100380 <panic>
80103412:	66 90                	xchg   %ax,%ax
80103414:	66 90                	xchg   %ax,%ax
80103416:	66 90                	xchg   %ax,%ax
80103418:	66 90                	xchg   %ax,%ax
8010341a:	66 90                	xchg   %ax,%ax
8010341c:	66 90                	xchg   %ax,%ax
8010341e:	66 90                	xchg   %ax,%ax

80103420 <picinit>:
80103420:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103425:	ba 21 00 00 00       	mov    $0x21,%edx
8010342a:	ee                   	out    %al,(%dx)
8010342b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103430:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103431:	c3                   	ret    
80103432:	66 90                	xchg   %ax,%ax
80103434:	66 90                	xchg   %ax,%ax
80103436:	66 90                	xchg   %ax,%ax
80103438:	66 90                	xchg   %ax,%ax
8010343a:	66 90                	xchg   %ax,%ax
8010343c:	66 90                	xchg   %ax,%ax
8010343e:	66 90                	xchg   %ax,%ax

80103440 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103440:	55                   	push   %ebp
80103441:	89 e5                	mov    %esp,%ebp
80103443:	57                   	push   %edi
80103444:	56                   	push   %esi
80103445:	53                   	push   %ebx
80103446:	83 ec 0c             	sub    $0xc,%esp
80103449:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010344c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010344f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103455:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010345b:	e8 e0 d9 ff ff       	call   80100e40 <filealloc>
80103460:	89 03                	mov    %eax,(%ebx)
80103462:	85 c0                	test   %eax,%eax
80103464:	0f 84 a8 00 00 00    	je     80103512 <pipealloc+0xd2>
8010346a:	e8 d1 d9 ff ff       	call   80100e40 <filealloc>
8010346f:	89 06                	mov    %eax,(%esi)
80103471:	85 c0                	test   %eax,%eax
80103473:	0f 84 87 00 00 00    	je     80103500 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103479:	e8 12 f2 ff ff       	call   80102690 <kalloc>
8010347e:	89 c7                	mov    %eax,%edi
80103480:	85 c0                	test   %eax,%eax
80103482:	0f 84 b0 00 00 00    	je     80103538 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103488:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010348f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103492:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103495:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010349c:	00 00 00 
  p->nwrite = 0;
8010349f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034a6:	00 00 00 
  p->nread = 0;
801034a9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034b0:	00 00 00 
  initlock(&p->lock, "pipe");
801034b3:	68 bb 8b 10 80       	push   $0x80108bbb
801034b8:	50                   	push   %eax
801034b9:	e8 52 10 00 00       	call   80104510 <initlock>
  (*f0)->type = FD_PIPE;
801034be:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034c0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034c3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034c9:	8b 03                	mov    (%ebx),%eax
801034cb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034cf:	8b 03                	mov    (%ebx),%eax
801034d1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034d5:	8b 03                	mov    (%ebx),%eax
801034d7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034da:	8b 06                	mov    (%esi),%eax
801034dc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034e2:	8b 06                	mov    (%esi),%eax
801034e4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034e8:	8b 06                	mov    (%esi),%eax
801034ea:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034ee:	8b 06                	mov    (%esi),%eax
801034f0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034f6:	31 c0                	xor    %eax,%eax
}
801034f8:	5b                   	pop    %ebx
801034f9:	5e                   	pop    %esi
801034fa:	5f                   	pop    %edi
801034fb:	5d                   	pop    %ebp
801034fc:	c3                   	ret    
801034fd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103500:	8b 03                	mov    (%ebx),%eax
80103502:	85 c0                	test   %eax,%eax
80103504:	74 1e                	je     80103524 <pipealloc+0xe4>
    fileclose(*f0);
80103506:	83 ec 0c             	sub    $0xc,%esp
80103509:	50                   	push   %eax
8010350a:	e8 f1 d9 ff ff       	call   80100f00 <fileclose>
8010350f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103512:	8b 06                	mov    (%esi),%eax
80103514:	85 c0                	test   %eax,%eax
80103516:	74 0c                	je     80103524 <pipealloc+0xe4>
    fileclose(*f1);
80103518:	83 ec 0c             	sub    $0xc,%esp
8010351b:	50                   	push   %eax
8010351c:	e8 df d9 ff ff       	call   80100f00 <fileclose>
80103521:	83 c4 10             	add    $0x10,%esp
}
80103524:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103527:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010352c:	5b                   	pop    %ebx
8010352d:	5e                   	pop    %esi
8010352e:	5f                   	pop    %edi
8010352f:	5d                   	pop    %ebp
80103530:	c3                   	ret    
80103531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103538:	8b 03                	mov    (%ebx),%eax
8010353a:	85 c0                	test   %eax,%eax
8010353c:	75 c8                	jne    80103506 <pipealloc+0xc6>
8010353e:	eb d2                	jmp    80103512 <pipealloc+0xd2>

80103540 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103540:	55                   	push   %ebp
80103541:	89 e5                	mov    %esp,%ebp
80103543:	56                   	push   %esi
80103544:	53                   	push   %ebx
80103545:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103548:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010354b:	83 ec 0c             	sub    $0xc,%esp
8010354e:	53                   	push   %ebx
8010354f:	e8 8c 11 00 00       	call   801046e0 <acquire>
  if(writable){
80103554:	83 c4 10             	add    $0x10,%esp
80103557:	85 f6                	test   %esi,%esi
80103559:	74 65                	je     801035c0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010355b:	83 ec 0c             	sub    $0xc,%esp
8010355e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103564:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010356b:	00 00 00 
    wakeup(&p->nread);
8010356e:	50                   	push   %eax
8010356f:	e8 cc 0c 00 00       	call   80104240 <wakeup>
80103574:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103577:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010357d:	85 d2                	test   %edx,%edx
8010357f:	75 0a                	jne    8010358b <pipeclose+0x4b>
80103581:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103587:	85 c0                	test   %eax,%eax
80103589:	74 15                	je     801035a0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010358b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010358e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103591:	5b                   	pop    %ebx
80103592:	5e                   	pop    %esi
80103593:	5d                   	pop    %ebp
    release(&p->lock);
80103594:	e9 e7 10 00 00       	jmp    80104680 <release>
80103599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801035a0:	83 ec 0c             	sub    $0xc,%esp
801035a3:	53                   	push   %ebx
801035a4:	e8 d7 10 00 00       	call   80104680 <release>
    kfree((char*)p);
801035a9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801035ac:	83 c4 10             	add    $0x10,%esp
}
801035af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035b2:	5b                   	pop    %ebx
801035b3:	5e                   	pop    %esi
801035b4:	5d                   	pop    %ebp
    kfree((char*)p);
801035b5:	e9 16 ef ff ff       	jmp    801024d0 <kfree>
801035ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035c0:	83 ec 0c             	sub    $0xc,%esp
801035c3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035c9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035d0:	00 00 00 
    wakeup(&p->nwrite);
801035d3:	50                   	push   %eax
801035d4:	e8 67 0c 00 00       	call   80104240 <wakeup>
801035d9:	83 c4 10             	add    $0x10,%esp
801035dc:	eb 99                	jmp    80103577 <pipeclose+0x37>
801035de:	66 90                	xchg   %ax,%ax

801035e0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035e0:	55                   	push   %ebp
801035e1:	89 e5                	mov    %esp,%ebp
801035e3:	57                   	push   %edi
801035e4:	56                   	push   %esi
801035e5:	53                   	push   %ebx
801035e6:	83 ec 28             	sub    $0x28,%esp
801035e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035ec:	53                   	push   %ebx
801035ed:	e8 ee 10 00 00       	call   801046e0 <acquire>
  for(i = 0; i < n; i++){
801035f2:	8b 45 10             	mov    0x10(%ebp),%eax
801035f5:	83 c4 10             	add    $0x10,%esp
801035f8:	85 c0                	test   %eax,%eax
801035fa:	0f 8e c0 00 00 00    	jle    801036c0 <pipewrite+0xe0>
80103600:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103603:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103609:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010360f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103612:	03 45 10             	add    0x10(%ebp),%eax
80103615:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103618:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010361e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103624:	89 ca                	mov    %ecx,%edx
80103626:	05 00 02 00 00       	add    $0x200,%eax
8010362b:	39 c1                	cmp    %eax,%ecx
8010362d:	74 3f                	je     8010366e <pipewrite+0x8e>
8010362f:	eb 67                	jmp    80103698 <pipewrite+0xb8>
80103631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103638:	e8 a3 03 00 00       	call   801039e0 <myproc>
8010363d:	8b 48 24             	mov    0x24(%eax),%ecx
80103640:	85 c9                	test   %ecx,%ecx
80103642:	75 34                	jne    80103678 <pipewrite+0x98>
      wakeup(&p->nread);
80103644:	83 ec 0c             	sub    $0xc,%esp
80103647:	57                   	push   %edi
80103648:	e8 f3 0b 00 00       	call   80104240 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010364d:	58                   	pop    %eax
8010364e:	5a                   	pop    %edx
8010364f:	53                   	push   %ebx
80103650:	56                   	push   %esi
80103651:	e8 2a 0b 00 00       	call   80104180 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103656:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010365c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103662:	83 c4 10             	add    $0x10,%esp
80103665:	05 00 02 00 00       	add    $0x200,%eax
8010366a:	39 c2                	cmp    %eax,%edx
8010366c:	75 2a                	jne    80103698 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010366e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103674:	85 c0                	test   %eax,%eax
80103676:	75 c0                	jne    80103638 <pipewrite+0x58>
        release(&p->lock);
80103678:	83 ec 0c             	sub    $0xc,%esp
8010367b:	53                   	push   %ebx
8010367c:	e8 ff 0f 00 00       	call   80104680 <release>
        return -1;
80103681:	83 c4 10             	add    $0x10,%esp
80103684:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103689:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010368c:	5b                   	pop    %ebx
8010368d:	5e                   	pop    %esi
8010368e:	5f                   	pop    %edi
8010368f:	5d                   	pop    %ebp
80103690:	c3                   	ret    
80103691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103698:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010369b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010369e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801036a4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801036aa:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
801036ad:	83 c6 01             	add    $0x1,%esi
801036b0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036b3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036b7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801036ba:	0f 85 58 ff ff ff    	jne    80103618 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036c0:	83 ec 0c             	sub    $0xc,%esp
801036c3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036c9:	50                   	push   %eax
801036ca:	e8 71 0b 00 00       	call   80104240 <wakeup>
  release(&p->lock);
801036cf:	89 1c 24             	mov    %ebx,(%esp)
801036d2:	e8 a9 0f 00 00       	call   80104680 <release>
  return n;
801036d7:	8b 45 10             	mov    0x10(%ebp),%eax
801036da:	83 c4 10             	add    $0x10,%esp
801036dd:	eb aa                	jmp    80103689 <pipewrite+0xa9>
801036df:	90                   	nop

801036e0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036e0:	55                   	push   %ebp
801036e1:	89 e5                	mov    %esp,%ebp
801036e3:	57                   	push   %edi
801036e4:	56                   	push   %esi
801036e5:	53                   	push   %ebx
801036e6:	83 ec 18             	sub    $0x18,%esp
801036e9:	8b 75 08             	mov    0x8(%ebp),%esi
801036ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036ef:	56                   	push   %esi
801036f0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036f6:	e8 e5 0f 00 00       	call   801046e0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036fb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103701:	83 c4 10             	add    $0x10,%esp
80103704:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010370a:	74 2f                	je     8010373b <piperead+0x5b>
8010370c:	eb 37                	jmp    80103745 <piperead+0x65>
8010370e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103710:	e8 cb 02 00 00       	call   801039e0 <myproc>
80103715:	8b 48 24             	mov    0x24(%eax),%ecx
80103718:	85 c9                	test   %ecx,%ecx
8010371a:	0f 85 80 00 00 00    	jne    801037a0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103720:	83 ec 08             	sub    $0x8,%esp
80103723:	56                   	push   %esi
80103724:	53                   	push   %ebx
80103725:	e8 56 0a 00 00       	call   80104180 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010372a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103730:	83 c4 10             	add    $0x10,%esp
80103733:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103739:	75 0a                	jne    80103745 <piperead+0x65>
8010373b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103741:	85 c0                	test   %eax,%eax
80103743:	75 cb                	jne    80103710 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103745:	8b 55 10             	mov    0x10(%ebp),%edx
80103748:	31 db                	xor    %ebx,%ebx
8010374a:	85 d2                	test   %edx,%edx
8010374c:	7f 20                	jg     8010376e <piperead+0x8e>
8010374e:	eb 2c                	jmp    8010377c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103750:	8d 48 01             	lea    0x1(%eax),%ecx
80103753:	25 ff 01 00 00       	and    $0x1ff,%eax
80103758:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010375e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103763:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103766:	83 c3 01             	add    $0x1,%ebx
80103769:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010376c:	74 0e                	je     8010377c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010376e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103774:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010377a:	75 d4                	jne    80103750 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010377c:	83 ec 0c             	sub    $0xc,%esp
8010377f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103785:	50                   	push   %eax
80103786:	e8 b5 0a 00 00       	call   80104240 <wakeup>
  release(&p->lock);
8010378b:	89 34 24             	mov    %esi,(%esp)
8010378e:	e8 ed 0e 00 00       	call   80104680 <release>
  return i;
80103793:	83 c4 10             	add    $0x10,%esp
}
80103796:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103799:	89 d8                	mov    %ebx,%eax
8010379b:	5b                   	pop    %ebx
8010379c:	5e                   	pop    %esi
8010379d:	5f                   	pop    %edi
8010379e:	5d                   	pop    %ebp
8010379f:	c3                   	ret    
      release(&p->lock);
801037a0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801037a3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801037a8:	56                   	push   %esi
801037a9:	e8 d2 0e 00 00       	call   80104680 <release>
      return -1;
801037ae:	83 c4 10             	add    $0x10,%esp
}
801037b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037b4:	89 d8                	mov    %ebx,%eax
801037b6:	5b                   	pop    %ebx
801037b7:	5e                   	pop    %esi
801037b8:	5f                   	pop    %edi
801037b9:	5d                   	pop    %ebp
801037ba:	c3                   	ret    
801037bb:	66 90                	xchg   %ax,%ax
801037bd:	66 90                	xchg   %ax,%ax
801037bf:	90                   	nop

801037c0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037c0:	55                   	push   %ebp
801037c1:	89 e5                	mov    %esp,%ebp
801037c3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037c4:	bb 74 3d 21 80       	mov    $0x80213d74,%ebx
{
801037c9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037cc:	68 40 3d 21 80       	push   $0x80213d40
801037d1:	e8 0a 0f 00 00       	call   801046e0 <acquire>
801037d6:	83 c4 10             	add    $0x10,%esp
801037d9:	eb 17                	jmp    801037f2 <allocproc+0x32>
801037db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037df:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037e0:	81 c3 c0 01 00 00    	add    $0x1c0,%ebx
801037e6:	81 fb 74 ad 21 80    	cmp    $0x8021ad74,%ebx
801037ec:	0f 84 ce 00 00 00    	je     801038c0 <allocproc+0x100>
    if(p->state == UNUSED)
801037f2:	8b 43 0c             	mov    0xc(%ebx),%eax
801037f5:	85 c0                	test   %eax,%eax
801037f7:	75 e7                	jne    801037e0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037f9:	a1 04 c0 10 80       	mov    0x8010c004,%eax

  release(&ptable.lock);
801037fe:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103801:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103808:	89 43 10             	mov    %eax,0x10(%ebx)
8010380b:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
8010380e:	68 40 3d 21 80       	push   $0x80213d40
  p->pid = nextpid++;
80103813:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
  release(&ptable.lock);
80103819:	e8 62 0e 00 00       	call   80104680 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010381e:	e8 6d ee ff ff       	call   80102690 <kalloc>
80103823:	83 c4 10             	add    $0x10,%esp
80103826:	89 43 08             	mov    %eax,0x8(%ebx)
80103829:	85 c0                	test   %eax,%eax
8010382b:	0f 84 a8 00 00 00    	je     801038d9 <allocproc+0x119>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103831:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103837:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010383a:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010383f:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103842:	c7 40 14 b7 5b 10 80 	movl   $0x80105bb7,0x14(%eax)
  p->context = (struct context*)sp;
80103849:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010384c:	6a 14                	push   $0x14
8010384e:	6a 00                	push   $0x0
80103850:	50                   	push   %eax
80103851:	e8 4a 0f 00 00       	call   801047a0 <memset>
  p->context->eip = (uint)forkret;
80103856:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103859:	8d 93 c0 00 00 00    	lea    0xc0(%ebx),%edx
8010385f:	83 c4 10             	add    $0x10,%esp
80103862:	c7 40 10 f0 38 10 80 	movl   $0x801038f0,0x10(%eax)
  // initialize the process wmap
  p->wmapInfo.total_mmaps = 0;
80103869:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
8010386f:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  for(int i = 0; i<MAX_WMMAP_INFO; i++){
80103876:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010387d:	8d 76 00             	lea    0x0(%esi),%esi
	((p->wmapInfo).addr)[i] = 0;
80103880:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(int i = 0; i<MAX_WMMAP_INFO; i++){
80103886:	83 c0 04             	add    $0x4,%eax
	((p->wmapInfo).length)[i] = -1;
80103889:	c7 40 3c ff ff ff ff 	movl   $0xffffffff,0x3c(%eax)
    ((p->wmapInfo).n_loaded_pages)[i] = 0;
80103890:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
	((p->wmapInfoExtra).file_backed)[i] = 0;
80103897:	c7 80 bc 00 00 00 00 	movl   $0x0,0xbc(%eax)
8010389e:	00 00 00 
	((p->wmapInfoExtra).fd)[i] = -1;
801038a1:	c7 80 fc 00 00 00 ff 	movl   $0xffffffff,0xfc(%eax)
801038a8:	ff ff ff 
  for(int i = 0; i<MAX_WMMAP_INFO; i++){
801038ab:	39 d0                	cmp    %edx,%eax
801038ad:	75 d1                	jne    80103880 <allocproc+0xc0>
  }

  return p;
}
801038af:	89 d8                	mov    %ebx,%eax
801038b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038b4:	c9                   	leave  
801038b5:	c3                   	ret    
801038b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038bd:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ptable.lock);
801038c0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801038c3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801038c5:	68 40 3d 21 80       	push   $0x80213d40
801038ca:	e8 b1 0d 00 00       	call   80104680 <release>
}
801038cf:	89 d8                	mov    %ebx,%eax
  return 0;
801038d1:	83 c4 10             	add    $0x10,%esp
}
801038d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038d7:	c9                   	leave  
801038d8:	c3                   	ret    
    p->state = UNUSED;
801038d9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801038e0:	31 db                	xor    %ebx,%ebx
}
801038e2:	89 d8                	mov    %ebx,%eax
801038e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038e7:	c9                   	leave  
801038e8:	c3                   	ret    
801038e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801038f0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038f6:	68 40 3d 21 80       	push   $0x80213d40
801038fb:	e8 80 0d 00 00       	call   80104680 <release>

  if (first) {
80103900:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80103905:	83 c4 10             	add    $0x10,%esp
80103908:	85 c0                	test   %eax,%eax
8010390a:	75 04                	jne    80103910 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010390c:	c9                   	leave  
8010390d:	c3                   	ret    
8010390e:	66 90                	xchg   %ax,%ax
    first = 0;
80103910:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
80103917:	00 00 00 
    iinit(ROOTDEV);
8010391a:	83 ec 0c             	sub    $0xc,%esp
8010391d:	6a 01                	push   $0x1
8010391f:	e8 4c dc ff ff       	call   80101570 <iinit>
    initlog(ROOTDEV);
80103924:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010392b:	e8 a0 f3 ff ff       	call   80102cd0 <initlog>
}
80103930:	83 c4 10             	add    $0x10,%esp
80103933:	c9                   	leave  
80103934:	c3                   	ret    
80103935:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010393c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103940 <pinit>:
{
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103946:	68 c0 8b 10 80       	push   $0x80108bc0
8010394b:	68 40 3d 21 80       	push   $0x80213d40
80103950:	e8 bb 0b 00 00       	call   80104510 <initlock>
}
80103955:	83 c4 10             	add    $0x10,%esp
80103958:	c9                   	leave  
80103959:	c3                   	ret    
8010395a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103960 <mycpu>:
{
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	56                   	push   %esi
80103964:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103965:	9c                   	pushf  
80103966:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103967:	f6 c4 02             	test   $0x2,%ah
8010396a:	75 46                	jne    801039b2 <mycpu+0x52>
  apicid = lapicid();
8010396c:	e8 8f ef ff ff       	call   80102900 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103971:	8b 35 a4 37 21 80    	mov    0x802137a4,%esi
80103977:	85 f6                	test   %esi,%esi
80103979:	7e 2a                	jle    801039a5 <mycpu+0x45>
8010397b:	31 d2                	xor    %edx,%edx
8010397d:	eb 08                	jmp    80103987 <mycpu+0x27>
8010397f:	90                   	nop
80103980:	83 c2 01             	add    $0x1,%edx
80103983:	39 f2                	cmp    %esi,%edx
80103985:	74 1e                	je     801039a5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103987:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010398d:	0f b6 99 c0 37 21 80 	movzbl -0x7fdec840(%ecx),%ebx
80103994:	39 c3                	cmp    %eax,%ebx
80103996:	75 e8                	jne    80103980 <mycpu+0x20>
}
80103998:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010399b:	8d 81 c0 37 21 80    	lea    -0x7fdec840(%ecx),%eax
}
801039a1:	5b                   	pop    %ebx
801039a2:	5e                   	pop    %esi
801039a3:	5d                   	pop    %ebp
801039a4:	c3                   	ret    
  panic("unknown apicid\n");
801039a5:	83 ec 0c             	sub    $0xc,%esp
801039a8:	68 c7 8b 10 80       	push   $0x80108bc7
801039ad:	e8 ce c9 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
801039b2:	83 ec 0c             	sub    $0xc,%esp
801039b5:	68 bc 8c 10 80       	push   $0x80108cbc
801039ba:	e8 c1 c9 ff ff       	call   80100380 <panic>
801039bf:	90                   	nop

801039c0 <cpuid>:
cpuid() {
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801039c6:	e8 95 ff ff ff       	call   80103960 <mycpu>
}
801039cb:	c9                   	leave  
  return mycpu()-cpus;
801039cc:	2d c0 37 21 80       	sub    $0x802137c0,%eax
801039d1:	c1 f8 04             	sar    $0x4,%eax
801039d4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801039da:	c3                   	ret    
801039db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039df:	90                   	nop

801039e0 <myproc>:
myproc(void) {
801039e0:	55                   	push   %ebp
801039e1:	89 e5                	mov    %esp,%ebp
801039e3:	53                   	push   %ebx
801039e4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801039e7:	e8 a4 0b 00 00       	call   80104590 <pushcli>
  c = mycpu();
801039ec:	e8 6f ff ff ff       	call   80103960 <mycpu>
  p = c->proc;
801039f1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039f7:	e8 e4 0b 00 00       	call   801045e0 <popcli>
}
801039fc:	89 d8                	mov    %ebx,%eax
801039fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a01:	c9                   	leave  
80103a02:	c3                   	ret    
80103a03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a10 <userinit>:
{
80103a10:	55                   	push   %ebp
80103a11:	89 e5                	mov    %esp,%ebp
80103a13:	53                   	push   %ebx
80103a14:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103a17:	e8 a4 fd ff ff       	call   801037c0 <allocproc>
80103a1c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103a1e:	a3 74 ad 21 80       	mov    %eax,0x8021ad74
  if((p->pgdir = setupkvm()) == 0)
80103a23:	e8 d8 39 00 00       	call   80107400 <setupkvm>
80103a28:	89 43 04             	mov    %eax,0x4(%ebx)
80103a2b:	85 c0                	test   %eax,%eax
80103a2d:	0f 84 bd 00 00 00    	je     80103af0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a33:	83 ec 04             	sub    $0x4,%esp
80103a36:	68 2c 00 00 00       	push   $0x2c
80103a3b:	68 60 c4 10 80       	push   $0x8010c460
80103a40:	50                   	push   %eax
80103a41:	e8 ca 35 00 00       	call   80107010 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a46:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a49:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a4f:	6a 4c                	push   $0x4c
80103a51:	6a 00                	push   $0x0
80103a53:	ff 73 18             	push   0x18(%ebx)
80103a56:	e8 45 0d 00 00       	call   801047a0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a5b:	8b 43 18             	mov    0x18(%ebx),%eax
80103a5e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a63:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a66:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a6b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a6f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a72:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a76:	8b 43 18             	mov    0x18(%ebx),%eax
80103a79:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a7d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a81:	8b 43 18             	mov    0x18(%ebx),%eax
80103a84:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a88:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a8c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a8f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a96:	8b 43 18             	mov    0x18(%ebx),%eax
80103a99:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103aa0:	8b 43 18             	mov    0x18(%ebx),%eax
80103aa3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103aaa:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103aad:	6a 10                	push   $0x10
80103aaf:	68 f0 8b 10 80       	push   $0x80108bf0
80103ab4:	50                   	push   %eax
80103ab5:	e8 a6 0e 00 00       	call   80104960 <safestrcpy>
  p->cwd = namei("/");
80103aba:	c7 04 24 f9 8b 10 80 	movl   $0x80108bf9,(%esp)
80103ac1:	e8 ea e5 ff ff       	call   801020b0 <namei>
80103ac6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103ac9:	c7 04 24 40 3d 21 80 	movl   $0x80213d40,(%esp)
80103ad0:	e8 0b 0c 00 00       	call   801046e0 <acquire>
  p->state = RUNNABLE;
80103ad5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103adc:	c7 04 24 40 3d 21 80 	movl   $0x80213d40,(%esp)
80103ae3:	e8 98 0b 00 00       	call   80104680 <release>
}
80103ae8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103aeb:	83 c4 10             	add    $0x10,%esp
80103aee:	c9                   	leave  
80103aef:	c3                   	ret    
    panic("userinit: out of memory?");
80103af0:	83 ec 0c             	sub    $0xc,%esp
80103af3:	68 d7 8b 10 80       	push   $0x80108bd7
80103af8:	e8 83 c8 ff ff       	call   80100380 <panic>
80103afd:	8d 76 00             	lea    0x0(%esi),%esi

80103b00 <growproc>:
{
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	56                   	push   %esi
80103b04:	53                   	push   %ebx
80103b05:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103b08:	e8 83 0a 00 00       	call   80104590 <pushcli>
  c = mycpu();
80103b0d:	e8 4e fe ff ff       	call   80103960 <mycpu>
  p = c->proc;
80103b12:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b18:	e8 c3 0a 00 00       	call   801045e0 <popcli>
  sz = curproc->sz;
80103b1d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103b1f:	85 f6                	test   %esi,%esi
80103b21:	7f 1d                	jg     80103b40 <growproc+0x40>
  } else if(n < 0){
80103b23:	75 3b                	jne    80103b60 <growproc+0x60>
  switchuvm(curproc);
80103b25:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103b28:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103b2a:	53                   	push   %ebx
80103b2b:	e8 d0 33 00 00       	call   80106f00 <switchuvm>
  return 0;
80103b30:	83 c4 10             	add    $0x10,%esp
80103b33:	31 c0                	xor    %eax,%eax
}
80103b35:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b38:	5b                   	pop    %ebx
80103b39:	5e                   	pop    %esi
80103b3a:	5d                   	pop    %ebp
80103b3b:	c3                   	ret    
80103b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b40:	83 ec 04             	sub    $0x4,%esp
80103b43:	01 c6                	add    %eax,%esi
80103b45:	56                   	push   %esi
80103b46:	50                   	push   %eax
80103b47:	ff 73 04             	push   0x4(%ebx)
80103b4a:	e8 61 36 00 00       	call   801071b0 <allocuvm>
80103b4f:	83 c4 10             	add    $0x10,%esp
80103b52:	85 c0                	test   %eax,%eax
80103b54:	75 cf                	jne    80103b25 <growproc+0x25>
      return -1;
80103b56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b5b:	eb d8                	jmp    80103b35 <growproc+0x35>
80103b5d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b60:	83 ec 04             	sub    $0x4,%esp
80103b63:	01 c6                	add    %eax,%esi
80103b65:	56                   	push   %esi
80103b66:	50                   	push   %eax
80103b67:	ff 73 04             	push   0x4(%ebx)
80103b6a:	e8 a1 37 00 00       	call   80107310 <deallocuvm>
80103b6f:	83 c4 10             	add    $0x10,%esp
80103b72:	85 c0                	test   %eax,%eax
80103b74:	75 af                	jne    80103b25 <growproc+0x25>
80103b76:	eb de                	jmp    80103b56 <growproc+0x56>
80103b78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b7f:	90                   	nop

80103b80 <fork>:
{
80103b80:	55                   	push   %ebp
80103b81:	89 e5                	mov    %esp,%ebp
80103b83:	57                   	push   %edi
80103b84:	56                   	push   %esi
80103b85:	53                   	push   %ebx
80103b86:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b89:	e8 02 0a 00 00       	call   80104590 <pushcli>
  c = mycpu();
80103b8e:	e8 cd fd ff ff       	call   80103960 <mycpu>
  p = c->proc;
80103b93:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b99:	e8 42 0a 00 00       	call   801045e0 <popcli>
  if((np = allocproc()) == 0){
80103b9e:	e8 1d fc ff ff       	call   801037c0 <allocproc>
80103ba3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103ba6:	85 c0                	test   %eax,%eax
80103ba8:	0f 84 42 01 00 00    	je     80103cf0 <fork+0x170>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103bae:	83 ec 08             	sub    $0x8,%esp
80103bb1:	ff 33                	push   (%ebx)
80103bb3:	89 c7                	mov    %eax,%edi
80103bb5:	ff 73 04             	push   0x4(%ebx)
80103bb8:	e8 33 39 00 00       	call   801074f0 <copyuvm>
80103bbd:	83 c4 10             	add    $0x10,%esp
80103bc0:	89 47 04             	mov    %eax,0x4(%edi)
80103bc3:	85 c0                	test   %eax,%eax
80103bc5:	0f 84 ff 00 00 00    	je     80103cca <fork+0x14a>
  lcr3(V2P(curproc->pgdir));
80103bcb:	8b 4b 04             	mov    0x4(%ebx),%ecx
80103bce:	8d 91 00 00 00 80    	lea    -0x80000000(%ecx),%edx
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80103bd4:	0f 22 da             	mov    %edx,%cr3
  lcr3(V2P(np->pgdir));
80103bd7:	05 00 00 00 80       	add    $0x80000000,%eax
80103bdc:	0f 22 d8             	mov    %eax,%cr3
  np->sz = curproc->sz;
80103bdf:	8b 03                	mov    (%ebx),%eax
80103be1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103be4:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103be6:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103be9:	89 c8                	mov    %ecx,%eax
80103beb:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103bee:	b9 13 00 00 00       	mov    $0x13,%ecx
80103bf3:	8b 73 18             	mov    0x18(%ebx),%esi
80103bf6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103bf8:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103bfa:	8b 40 18             	mov    0x18(%eax),%eax
80103bfd:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103c08:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103c0c:	85 c0                	test   %eax,%eax
80103c0e:	74 13                	je     80103c23 <fork+0xa3>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103c10:	83 ec 0c             	sub    $0xc,%esp
80103c13:	50                   	push   %eax
80103c14:	e8 97 d2 ff ff       	call   80100eb0 <filedup>
80103c19:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103c1c:	83 c4 10             	add    $0x10,%esp
80103c1f:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103c23:	83 c6 01             	add    $0x1,%esi
80103c26:	83 fe 10             	cmp    $0x10,%esi
80103c29:	75 dd                	jne    80103c08 <fork+0x88>
  np->cwd = idup(curproc->cwd);
80103c2b:	83 ec 0c             	sub    $0xc,%esp
80103c2e:	ff 73 68             	push   0x68(%ebx)
80103c31:	e8 2a db ff ff       	call   80101760 <idup>
80103c36:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c39:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103c3c:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c3f:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103c42:	6a 10                	push   $0x10
80103c44:	50                   	push   %eax
80103c45:	8d 47 6c             	lea    0x6c(%edi),%eax
80103c48:	50                   	push   %eax
80103c49:	e8 12 0d 00 00       	call   80104960 <safestrcpy>
  pid = np->pid;
80103c4e:	8b 77 10             	mov    0x10(%edi),%esi
  acquire(&ptable.lock);
80103c51:	c7 04 24 40 3d 21 80 	movl   $0x80213d40,(%esp)
80103c58:	e8 83 0a 00 00       	call   801046e0 <acquire>
  np->state = RUNNABLE;
80103c5d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103c64:	c7 04 24 40 3d 21 80 	movl   $0x80213d40,(%esp)
80103c6b:	e8 10 0a 00 00       	call   80104680 <release>
  if(copyWmap(curproc, np) != 0){
80103c70:	59                   	pop    %ecx
80103c71:	58                   	pop    %eax
80103c72:	57                   	push   %edi
80103c73:	53                   	push   %ebx
80103c74:	e8 f7 3f 00 00       	call   80107c70 <copyWmap>
80103c79:	83 c4 10             	add    $0x10,%esp
80103c7c:	85 c0                	test   %eax,%eax
80103c7e:	75 30                	jne    80103cb0 <fork+0x130>
  if(DEBUG) printWmap(np);
80103c80:	a1 80 37 11 80       	mov    0x80113780,%eax
80103c85:	85 c0                	test   %eax,%eax
80103c87:	75 0f                	jne    80103c98 <fork+0x118>
}
80103c89:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c8c:	89 f0                	mov    %esi,%eax
80103c8e:	5b                   	pop    %ebx
80103c8f:	5e                   	pop    %esi
80103c90:	5f                   	pop    %edi
80103c91:	5d                   	pop    %ebp
80103c92:	c3                   	ret    
80103c93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c97:	90                   	nop
  if(DEBUG) printWmap(np);
80103c98:	83 ec 0c             	sub    $0xc,%esp
80103c9b:	ff 75 e4             	push   -0x1c(%ebp)
80103c9e:	e8 6d 3b 00 00       	call   80107810 <printWmap>
80103ca3:	83 c4 10             	add    $0x10,%esp
}
80103ca6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ca9:	89 f0                	mov    %esi,%eax
80103cab:	5b                   	pop    %ebx
80103cac:	5e                   	pop    %esi
80103cad:	5f                   	pop    %edi
80103cae:	5d                   	pop    %ebp
80103caf:	c3                   	ret    
	if(DEBUG) cprintf("FORK: COPYWMAP failed!\n");
80103cb0:	8b 15 80 37 11 80    	mov    0x80113780,%edx
80103cb6:	85 d2                	test   %edx,%edx
80103cb8:	74 10                	je     80103cca <fork+0x14a>
80103cba:	83 ec 0c             	sub    $0xc,%esp
80103cbd:	68 fb 8b 10 80       	push   $0x80108bfb
80103cc2:	e8 d9 c9 ff ff       	call   801006a0 <cprintf>
80103cc7:	83 c4 10             	add    $0x10,%esp
	kfree(np->kstack);
80103cca:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103ccd:	83 ec 0c             	sub    $0xc,%esp
	return -1;
80103cd0:	be ff ff ff ff       	mov    $0xffffffff,%esi
	kfree(np->kstack);
80103cd5:	ff 73 08             	push   0x8(%ebx)
80103cd8:	e8 f3 e7 ff ff       	call   801024d0 <kfree>
	np->kstack = 0;
80103cdd:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
80103ce4:	83 c4 10             	add    $0x10,%esp
	np->state = UNUSED;
80103ce7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
	return -1;
80103cee:	eb 99                	jmp    80103c89 <fork+0x109>
    return -1;
80103cf0:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103cf5:	eb 92                	jmp    80103c89 <fork+0x109>
80103cf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cfe:	66 90                	xchg   %ax,%ax

80103d00 <scheduler>:
{
80103d00:	55                   	push   %ebp
80103d01:	89 e5                	mov    %esp,%ebp
80103d03:	57                   	push   %edi
80103d04:	56                   	push   %esi
80103d05:	53                   	push   %ebx
80103d06:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103d09:	e8 52 fc ff ff       	call   80103960 <mycpu>
  c->proc = 0;
80103d0e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103d15:	00 00 00 
  struct cpu *c = mycpu();
80103d18:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103d1a:	8d 78 04             	lea    0x4(%eax),%edi
80103d1d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103d20:	fb                   	sti    
    acquire(&ptable.lock);
80103d21:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d24:	bb 74 3d 21 80       	mov    $0x80213d74,%ebx
    acquire(&ptable.lock);
80103d29:	68 40 3d 21 80       	push   $0x80213d40
80103d2e:	e8 ad 09 00 00       	call   801046e0 <acquire>
80103d33:	83 c4 10             	add    $0x10,%esp
80103d36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d3d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103d40:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103d44:	75 33                	jne    80103d79 <scheduler+0x79>
      switchuvm(p);
80103d46:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103d49:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103d4f:	53                   	push   %ebx
80103d50:	e8 ab 31 00 00       	call   80106f00 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103d55:	58                   	pop    %eax
80103d56:	5a                   	pop    %edx
80103d57:	ff 73 1c             	push   0x1c(%ebx)
80103d5a:	57                   	push   %edi
      p->state = RUNNING;
80103d5b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103d62:	e8 54 0c 00 00       	call   801049bb <swtch>
      switchkvm();
80103d67:	e8 84 31 00 00       	call   80106ef0 <switchkvm>
      c->proc = 0;
80103d6c:	83 c4 10             	add    $0x10,%esp
80103d6f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103d76:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d79:	81 c3 c0 01 00 00    	add    $0x1c0,%ebx
80103d7f:	81 fb 74 ad 21 80    	cmp    $0x8021ad74,%ebx
80103d85:	75 b9                	jne    80103d40 <scheduler+0x40>
    release(&ptable.lock);
80103d87:	83 ec 0c             	sub    $0xc,%esp
80103d8a:	68 40 3d 21 80       	push   $0x80213d40
80103d8f:	e8 ec 08 00 00       	call   80104680 <release>
    sti();
80103d94:	83 c4 10             	add    $0x10,%esp
80103d97:	eb 87                	jmp    80103d20 <scheduler+0x20>
80103d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103da0 <sched>:
{
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	56                   	push   %esi
80103da4:	53                   	push   %ebx
  pushcli();
80103da5:	e8 e6 07 00 00       	call   80104590 <pushcli>
  c = mycpu();
80103daa:	e8 b1 fb ff ff       	call   80103960 <mycpu>
  p = c->proc;
80103daf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103db5:	e8 26 08 00 00       	call   801045e0 <popcli>
  if(!holding(&ptable.lock))
80103dba:	83 ec 0c             	sub    $0xc,%esp
80103dbd:	68 40 3d 21 80       	push   $0x80213d40
80103dc2:	e8 79 08 00 00       	call   80104640 <holding>
80103dc7:	83 c4 10             	add    $0x10,%esp
80103dca:	85 c0                	test   %eax,%eax
80103dcc:	74 4f                	je     80103e1d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103dce:	e8 8d fb ff ff       	call   80103960 <mycpu>
80103dd3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103dda:	75 68                	jne    80103e44 <sched+0xa4>
  if(p->state == RUNNING)
80103ddc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103de0:	74 55                	je     80103e37 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103de2:	9c                   	pushf  
80103de3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103de4:	f6 c4 02             	test   $0x2,%ah
80103de7:	75 41                	jne    80103e2a <sched+0x8a>
  intena = mycpu()->intena;
80103de9:	e8 72 fb ff ff       	call   80103960 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103dee:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103df1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103df7:	e8 64 fb ff ff       	call   80103960 <mycpu>
80103dfc:	83 ec 08             	sub    $0x8,%esp
80103dff:	ff 70 04             	push   0x4(%eax)
80103e02:	53                   	push   %ebx
80103e03:	e8 b3 0b 00 00       	call   801049bb <swtch>
  mycpu()->intena = intena;
80103e08:	e8 53 fb ff ff       	call   80103960 <mycpu>
}
80103e0d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103e10:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103e16:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e19:	5b                   	pop    %ebx
80103e1a:	5e                   	pop    %esi
80103e1b:	5d                   	pop    %ebp
80103e1c:	c3                   	ret    
    panic("sched ptable.lock");
80103e1d:	83 ec 0c             	sub    $0xc,%esp
80103e20:	68 13 8c 10 80       	push   $0x80108c13
80103e25:	e8 56 c5 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103e2a:	83 ec 0c             	sub    $0xc,%esp
80103e2d:	68 3f 8c 10 80       	push   $0x80108c3f
80103e32:	e8 49 c5 ff ff       	call   80100380 <panic>
    panic("sched running");
80103e37:	83 ec 0c             	sub    $0xc,%esp
80103e3a:	68 31 8c 10 80       	push   $0x80108c31
80103e3f:	e8 3c c5 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103e44:	83 ec 0c             	sub    $0xc,%esp
80103e47:	68 25 8c 10 80       	push   $0x80108c25
80103e4c:	e8 2f c5 ff ff       	call   80100380 <panic>
80103e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e5f:	90                   	nop

80103e60 <exit>:
{
80103e60:	55                   	push   %ebp
80103e61:	89 e5                	mov    %esp,%ebp
80103e63:	57                   	push   %edi
80103e64:	56                   	push   %esi
80103e65:	53                   	push   %ebx
80103e66:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103e69:	e8 72 fb ff ff       	call   801039e0 <myproc>
  if(curproc == initproc)
80103e6e:	39 05 74 ad 21 80    	cmp    %eax,0x8021ad74
80103e74:	0f 84 77 01 00 00    	je     80103ff1 <exit+0x191>
80103e7a:	89 c6                	mov    %eax,%esi
80103e7c:	8d 98 80 00 00 00    	lea    0x80(%eax),%ebx
80103e82:	8d b8 c0 00 00 00    	lea    0xc0(%eax),%edi
80103e88:	eb 11                	jmp    80103e9b <exit+0x3b>
80103e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	if(addr == 0 && length == -1) continue;
80103e90:	85 c0                	test   %eax,%eax
80103e92:	75 0f                	jne    80103ea3 <exit+0x43>
  for(int i=0; i < MAX_WMMAP_INFO; i++){
80103e94:	83 c3 04             	add    $0x4,%ebx
80103e97:	39 df                	cmp    %ebx,%edi
80103e99:	74 1b                	je     80103eb6 <exit+0x56>
	if(addr == 0 && length == -1) continue;
80103e9b:	83 7b 40 ff          	cmpl   $0xffffffff,0x40(%ebx)
	addr = ((curproc->wmapInfo).addr)[i];
80103e9f:	8b 03                	mov    (%ebx),%eax
	if(addr == 0 && length == -1) continue;
80103ea1:	74 ed                	je     80103e90 <exit+0x30>
	wunmap(addr);  // unmap the address
80103ea3:	83 ec 0c             	sub    $0xc,%esp
  for(int i=0; i < MAX_WMMAP_INFO; i++){
80103ea6:	83 c3 04             	add    $0x4,%ebx
	wunmap(addr);  // unmap the address
80103ea9:	50                   	push   %eax
80103eaa:	e8 41 46 00 00       	call   801084f0 <wunmap>
80103eaf:	83 c4 10             	add    $0x10,%esp
  for(int i=0; i < MAX_WMMAP_INFO; i++){
80103eb2:	39 df                	cmp    %ebx,%edi
80103eb4:	75 e5                	jne    80103e9b <exit+0x3b>
80103eb6:	31 db                	xor    %ebx,%ebx
80103eb8:	eb 11                	jmp    80103ecb <exit+0x6b>
80103eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(int i = 0; i < NPDENTRIES; i++){
80103ec0:	83 c3 04             	add    $0x4,%ebx
80103ec3:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
80103ec9:	74 26                	je     80103ef1 <exit+0x91>
	if(curproc->pgdir[i] & PTE_P){
80103ecb:	8b 46 04             	mov    0x4(%esi),%eax
80103ece:	8b 04 18             	mov    (%eax,%ebx,1),%eax
80103ed1:	a8 01                	test   $0x1,%al
80103ed3:	74 eb                	je     80103ec0 <exit+0x60>
	  dec_count(PTE_ADDR(curproc->pgdir[i]));
80103ed5:	83 ec 0c             	sub    $0xc,%esp
80103ed8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  for(int i = 0; i < NPDENTRIES; i++){
80103edd:	83 c3 04             	add    $0x4,%ebx
	  dec_count(PTE_ADDR(curproc->pgdir[i]));
80103ee0:	50                   	push   %eax
80103ee1:	e8 9a 3f 00 00       	call   80107e80 <dec_count>
80103ee6:	83 c4 10             	add    $0x10,%esp
  for(int i = 0; i < NPDENTRIES; i++){
80103ee9:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
80103eef:	75 da                	jne    80103ecb <exit+0x6b>
80103ef1:	8d 5e 28             	lea    0x28(%esi),%ebx
80103ef4:	8d 7e 68             	lea    0x68(%esi),%edi
80103ef7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103efe:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd]){
80103f00:	8b 03                	mov    (%ebx),%eax
80103f02:	85 c0                	test   %eax,%eax
80103f04:	74 12                	je     80103f18 <exit+0xb8>
      fileclose(curproc->ofile[fd]);
80103f06:	83 ec 0c             	sub    $0xc,%esp
80103f09:	50                   	push   %eax
80103f0a:	e8 f1 cf ff ff       	call   80100f00 <fileclose>
      curproc->ofile[fd] = 0;
80103f0f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103f15:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103f18:	83 c3 04             	add    $0x4,%ebx
80103f1b:	39 df                	cmp    %ebx,%edi
80103f1d:	75 e1                	jne    80103f00 <exit+0xa0>
  begin_op();
80103f1f:	e8 4c ee ff ff       	call   80102d70 <begin_op>
  iput(curproc->cwd);
80103f24:	83 ec 0c             	sub    $0xc,%esp
80103f27:	ff 76 68             	push   0x68(%esi)
80103f2a:	e8 91 d9 ff ff       	call   801018c0 <iput>
  end_op();
80103f2f:	e8 ac ee ff ff       	call   80102de0 <end_op>
  curproc->cwd = 0;
80103f34:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103f3b:	c7 04 24 40 3d 21 80 	movl   $0x80213d40,(%esp)
80103f42:	e8 99 07 00 00       	call   801046e0 <acquire>
  wakeup1(curproc->parent);
80103f47:	8b 56 14             	mov    0x14(%esi),%edx
80103f4a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f4d:	b8 74 3d 21 80       	mov    $0x80213d74,%eax
80103f52:	eb 10                	jmp    80103f64 <exit+0x104>
80103f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f58:	05 c0 01 00 00       	add    $0x1c0,%eax
80103f5d:	3d 74 ad 21 80       	cmp    $0x8021ad74,%eax
80103f62:	74 1e                	je     80103f82 <exit+0x122>
    if(p->state == SLEEPING && p->chan == chan)
80103f64:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f68:	75 ee                	jne    80103f58 <exit+0xf8>
80103f6a:	3b 50 20             	cmp    0x20(%eax),%edx
80103f6d:	75 e9                	jne    80103f58 <exit+0xf8>
      p->state = RUNNABLE;
80103f6f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f76:	05 c0 01 00 00       	add    $0x1c0,%eax
80103f7b:	3d 74 ad 21 80       	cmp    $0x8021ad74,%eax
80103f80:	75 e2                	jne    80103f64 <exit+0x104>
      p->parent = initproc;
80103f82:	8b 0d 74 ad 21 80    	mov    0x8021ad74,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f88:	ba 74 3d 21 80       	mov    $0x80213d74,%edx
80103f8d:	eb 0f                	jmp    80103f9e <exit+0x13e>
80103f8f:	90                   	nop
80103f90:	81 c2 c0 01 00 00    	add    $0x1c0,%edx
80103f96:	81 fa 74 ad 21 80    	cmp    $0x8021ad74,%edx
80103f9c:	74 3a                	je     80103fd8 <exit+0x178>
    if(p->parent == curproc){
80103f9e:	39 72 14             	cmp    %esi,0x14(%edx)
80103fa1:	75 ed                	jne    80103f90 <exit+0x130>
      if(p->state == ZOMBIE)
80103fa3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103fa7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103faa:	75 e4                	jne    80103f90 <exit+0x130>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fac:	b8 74 3d 21 80       	mov    $0x80213d74,%eax
80103fb1:	eb 11                	jmp    80103fc4 <exit+0x164>
80103fb3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fb7:	90                   	nop
80103fb8:	05 c0 01 00 00       	add    $0x1c0,%eax
80103fbd:	3d 74 ad 21 80       	cmp    $0x8021ad74,%eax
80103fc2:	74 cc                	je     80103f90 <exit+0x130>
    if(p->state == SLEEPING && p->chan == chan)
80103fc4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103fc8:	75 ee                	jne    80103fb8 <exit+0x158>
80103fca:	3b 48 20             	cmp    0x20(%eax),%ecx
80103fcd:	75 e9                	jne    80103fb8 <exit+0x158>
      p->state = RUNNABLE;
80103fcf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103fd6:	eb e0                	jmp    80103fb8 <exit+0x158>
  curproc->state = ZOMBIE;
80103fd8:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103fdf:	e8 bc fd ff ff       	call   80103da0 <sched>
  panic("zombie exit");
80103fe4:	83 ec 0c             	sub    $0xc,%esp
80103fe7:	68 60 8c 10 80       	push   $0x80108c60
80103fec:	e8 8f c3 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103ff1:	83 ec 0c             	sub    $0xc,%esp
80103ff4:	68 53 8c 10 80       	push   $0x80108c53
80103ff9:	e8 82 c3 ff ff       	call   80100380 <panic>
80103ffe:	66 90                	xchg   %ax,%ax

80104000 <wait>:
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	56                   	push   %esi
80104004:	53                   	push   %ebx
  pushcli();
80104005:	e8 86 05 00 00       	call   80104590 <pushcli>
  c = mycpu();
8010400a:	e8 51 f9 ff ff       	call   80103960 <mycpu>
  p = c->proc;
8010400f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104015:	e8 c6 05 00 00       	call   801045e0 <popcli>
  acquire(&ptable.lock);
8010401a:	83 ec 0c             	sub    $0xc,%esp
8010401d:	68 40 3d 21 80       	push   $0x80213d40
80104022:	e8 b9 06 00 00       	call   801046e0 <acquire>
80104027:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010402a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010402c:	bb 74 3d 21 80       	mov    $0x80213d74,%ebx
80104031:	eb 13                	jmp    80104046 <wait+0x46>
80104033:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104037:	90                   	nop
80104038:	81 c3 c0 01 00 00    	add    $0x1c0,%ebx
8010403e:	81 fb 74 ad 21 80    	cmp    $0x8021ad74,%ebx
80104044:	74 1e                	je     80104064 <wait+0x64>
      if(p->parent != curproc)
80104046:	39 73 14             	cmp    %esi,0x14(%ebx)
80104049:	75 ed                	jne    80104038 <wait+0x38>
      if(p->state == ZOMBIE){
8010404b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010404f:	74 5f                	je     801040b0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104051:	81 c3 c0 01 00 00    	add    $0x1c0,%ebx
      havekids = 1;
80104057:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010405c:	81 fb 74 ad 21 80    	cmp    $0x8021ad74,%ebx
80104062:	75 e2                	jne    80104046 <wait+0x46>
    if(!havekids || curproc->killed){
80104064:	85 c0                	test   %eax,%eax
80104066:	0f 84 9a 00 00 00    	je     80104106 <wait+0x106>
8010406c:	8b 46 24             	mov    0x24(%esi),%eax
8010406f:	85 c0                	test   %eax,%eax
80104071:	0f 85 8f 00 00 00    	jne    80104106 <wait+0x106>
  pushcli();
80104077:	e8 14 05 00 00       	call   80104590 <pushcli>
  c = mycpu();
8010407c:	e8 df f8 ff ff       	call   80103960 <mycpu>
  p = c->proc;
80104081:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104087:	e8 54 05 00 00       	call   801045e0 <popcli>
  if(p == 0)
8010408c:	85 db                	test   %ebx,%ebx
8010408e:	0f 84 89 00 00 00    	je     8010411d <wait+0x11d>
  p->chan = chan;
80104094:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104097:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010409e:	e8 fd fc ff ff       	call   80103da0 <sched>
  p->chan = 0;
801040a3:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801040aa:	e9 7b ff ff ff       	jmp    8010402a <wait+0x2a>
801040af:	90                   	nop
        kfree(p->kstack);
801040b0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
801040b3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801040b6:	ff 73 08             	push   0x8(%ebx)
801040b9:	e8 12 e4 ff ff       	call   801024d0 <kfree>
        p->kstack = 0;
801040be:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801040c5:	5a                   	pop    %edx
801040c6:	ff 73 04             	push   0x4(%ebx)
801040c9:	e8 72 32 00 00       	call   80107340 <freevm>
        p->pid = 0;
801040ce:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801040d5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801040dc:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801040e0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801040e7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801040ee:	c7 04 24 40 3d 21 80 	movl   $0x80213d40,(%esp)
801040f5:	e8 86 05 00 00       	call   80104680 <release>
        return pid;
801040fa:	83 c4 10             	add    $0x10,%esp
}
801040fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104100:	89 f0                	mov    %esi,%eax
80104102:	5b                   	pop    %ebx
80104103:	5e                   	pop    %esi
80104104:	5d                   	pop    %ebp
80104105:	c3                   	ret    
      release(&ptable.lock);
80104106:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104109:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010410e:	68 40 3d 21 80       	push   $0x80213d40
80104113:	e8 68 05 00 00       	call   80104680 <release>
      return -1;
80104118:	83 c4 10             	add    $0x10,%esp
8010411b:	eb e0                	jmp    801040fd <wait+0xfd>
    panic("sleep");
8010411d:	83 ec 0c             	sub    $0xc,%esp
80104120:	68 6c 8c 10 80       	push   $0x80108c6c
80104125:	e8 56 c2 ff ff       	call   80100380 <panic>
8010412a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104130 <yield>:
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	53                   	push   %ebx
80104134:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104137:	68 40 3d 21 80       	push   $0x80213d40
8010413c:	e8 9f 05 00 00       	call   801046e0 <acquire>
  pushcli();
80104141:	e8 4a 04 00 00       	call   80104590 <pushcli>
  c = mycpu();
80104146:	e8 15 f8 ff ff       	call   80103960 <mycpu>
  p = c->proc;
8010414b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104151:	e8 8a 04 00 00       	call   801045e0 <popcli>
  myproc()->state = RUNNABLE;
80104156:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010415d:	e8 3e fc ff ff       	call   80103da0 <sched>
  release(&ptable.lock);
80104162:	c7 04 24 40 3d 21 80 	movl   $0x80213d40,(%esp)
80104169:	e8 12 05 00 00       	call   80104680 <release>
}
8010416e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104171:	83 c4 10             	add    $0x10,%esp
80104174:	c9                   	leave  
80104175:	c3                   	ret    
80104176:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010417d:	8d 76 00             	lea    0x0(%esi),%esi

80104180 <sleep>:
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	57                   	push   %edi
80104184:	56                   	push   %esi
80104185:	53                   	push   %ebx
80104186:	83 ec 0c             	sub    $0xc,%esp
80104189:	8b 7d 08             	mov    0x8(%ebp),%edi
8010418c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010418f:	e8 fc 03 00 00       	call   80104590 <pushcli>
  c = mycpu();
80104194:	e8 c7 f7 ff ff       	call   80103960 <mycpu>
  p = c->proc;
80104199:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010419f:	e8 3c 04 00 00       	call   801045e0 <popcli>
  if(p == 0)
801041a4:	85 db                	test   %ebx,%ebx
801041a6:	0f 84 87 00 00 00    	je     80104233 <sleep+0xb3>
  if(lk == 0)
801041ac:	85 f6                	test   %esi,%esi
801041ae:	74 76                	je     80104226 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801041b0:	81 fe 40 3d 21 80    	cmp    $0x80213d40,%esi
801041b6:	74 50                	je     80104208 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801041b8:	83 ec 0c             	sub    $0xc,%esp
801041bb:	68 40 3d 21 80       	push   $0x80213d40
801041c0:	e8 1b 05 00 00       	call   801046e0 <acquire>
    release(lk);
801041c5:	89 34 24             	mov    %esi,(%esp)
801041c8:	e8 b3 04 00 00       	call   80104680 <release>
  p->chan = chan;
801041cd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801041d0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801041d7:	e8 c4 fb ff ff       	call   80103da0 <sched>
  p->chan = 0;
801041dc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801041e3:	c7 04 24 40 3d 21 80 	movl   $0x80213d40,(%esp)
801041ea:	e8 91 04 00 00       	call   80104680 <release>
    acquire(lk);
801041ef:	89 75 08             	mov    %esi,0x8(%ebp)
801041f2:	83 c4 10             	add    $0x10,%esp
}
801041f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041f8:	5b                   	pop    %ebx
801041f9:	5e                   	pop    %esi
801041fa:	5f                   	pop    %edi
801041fb:	5d                   	pop    %ebp
    acquire(lk);
801041fc:	e9 df 04 00 00       	jmp    801046e0 <acquire>
80104201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104208:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010420b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104212:	e8 89 fb ff ff       	call   80103da0 <sched>
  p->chan = 0;
80104217:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010421e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104221:	5b                   	pop    %ebx
80104222:	5e                   	pop    %esi
80104223:	5f                   	pop    %edi
80104224:	5d                   	pop    %ebp
80104225:	c3                   	ret    
    panic("sleep without lk");
80104226:	83 ec 0c             	sub    $0xc,%esp
80104229:	68 72 8c 10 80       	push   $0x80108c72
8010422e:	e8 4d c1 ff ff       	call   80100380 <panic>
    panic("sleep");
80104233:	83 ec 0c             	sub    $0xc,%esp
80104236:	68 6c 8c 10 80       	push   $0x80108c6c
8010423b:	e8 40 c1 ff ff       	call   80100380 <panic>

80104240 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	53                   	push   %ebx
80104244:	83 ec 10             	sub    $0x10,%esp
80104247:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010424a:	68 40 3d 21 80       	push   $0x80213d40
8010424f:	e8 8c 04 00 00       	call   801046e0 <acquire>
80104254:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104257:	b8 74 3d 21 80       	mov    $0x80213d74,%eax
8010425c:	eb 0e                	jmp    8010426c <wakeup+0x2c>
8010425e:	66 90                	xchg   %ax,%ax
80104260:	05 c0 01 00 00       	add    $0x1c0,%eax
80104265:	3d 74 ad 21 80       	cmp    $0x8021ad74,%eax
8010426a:	74 1e                	je     8010428a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010426c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104270:	75 ee                	jne    80104260 <wakeup+0x20>
80104272:	3b 58 20             	cmp    0x20(%eax),%ebx
80104275:	75 e9                	jne    80104260 <wakeup+0x20>
      p->state = RUNNABLE;
80104277:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010427e:	05 c0 01 00 00       	add    $0x1c0,%eax
80104283:	3d 74 ad 21 80       	cmp    $0x8021ad74,%eax
80104288:	75 e2                	jne    8010426c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010428a:	c7 45 08 40 3d 21 80 	movl   $0x80213d40,0x8(%ebp)
}
80104291:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104294:	c9                   	leave  
  release(&ptable.lock);
80104295:	e9 e6 03 00 00       	jmp    80104680 <release>
8010429a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042a0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	53                   	push   %ebx
801042a4:	83 ec 10             	sub    $0x10,%esp
801042a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801042aa:	68 40 3d 21 80       	push   $0x80213d40
801042af:	e8 2c 04 00 00       	call   801046e0 <acquire>
801042b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042b7:	b8 74 3d 21 80       	mov    $0x80213d74,%eax
801042bc:	eb 0e                	jmp    801042cc <kill+0x2c>
801042be:	66 90                	xchg   %ax,%ax
801042c0:	05 c0 01 00 00       	add    $0x1c0,%eax
801042c5:	3d 74 ad 21 80       	cmp    $0x8021ad74,%eax
801042ca:	74 34                	je     80104300 <kill+0x60>
    if(p->pid == pid){
801042cc:	39 58 10             	cmp    %ebx,0x10(%eax)
801042cf:	75 ef                	jne    801042c0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801042d1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801042d5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801042dc:	75 07                	jne    801042e5 <kill+0x45>
        p->state = RUNNABLE;
801042de:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801042e5:	83 ec 0c             	sub    $0xc,%esp
801042e8:	68 40 3d 21 80       	push   $0x80213d40
801042ed:	e8 8e 03 00 00       	call   80104680 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801042f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801042f5:	83 c4 10             	add    $0x10,%esp
801042f8:	31 c0                	xor    %eax,%eax
}
801042fa:	c9                   	leave  
801042fb:	c3                   	ret    
801042fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104300:	83 ec 0c             	sub    $0xc,%esp
80104303:	68 40 3d 21 80       	push   $0x80213d40
80104308:	e8 73 03 00 00       	call   80104680 <release>
}
8010430d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104310:	83 c4 10             	add    $0x10,%esp
80104313:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104318:	c9                   	leave  
80104319:	c3                   	ret    
8010431a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104320 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
80104323:	57                   	push   %edi
80104324:	56                   	push   %esi
80104325:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104328:	53                   	push   %ebx
80104329:	bb e0 3d 21 80       	mov    $0x80213de0,%ebx
8010432e:	83 ec 3c             	sub    $0x3c,%esp
80104331:	eb 27                	jmp    8010435a <procdump+0x3a>
80104333:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104337:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104338:	83 ec 0c             	sub    $0xc,%esp
8010433b:	68 0e 92 10 80       	push   $0x8010920e
80104340:	e8 5b c3 ff ff       	call   801006a0 <cprintf>
80104345:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104348:	81 c3 c0 01 00 00    	add    $0x1c0,%ebx
8010434e:	81 fb e0 ad 21 80    	cmp    $0x8021ade0,%ebx
80104354:	0f 84 7e 00 00 00    	je     801043d8 <procdump+0xb8>
    if(p->state == UNUSED)
8010435a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010435d:	85 c0                	test   %eax,%eax
8010435f:	74 e7                	je     80104348 <procdump+0x28>
      state = "???";
80104361:	ba 83 8c 10 80       	mov    $0x80108c83,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104366:	83 f8 05             	cmp    $0x5,%eax
80104369:	77 11                	ja     8010437c <procdump+0x5c>
8010436b:	8b 14 85 e4 8c 10 80 	mov    -0x7fef731c(,%eax,4),%edx
      state = "???";
80104372:	b8 83 8c 10 80       	mov    $0x80108c83,%eax
80104377:	85 d2                	test   %edx,%edx
80104379:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010437c:	53                   	push   %ebx
8010437d:	52                   	push   %edx
8010437e:	ff 73 a4             	push   -0x5c(%ebx)
80104381:	68 87 8c 10 80       	push   $0x80108c87
80104386:	e8 15 c3 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
8010438b:	83 c4 10             	add    $0x10,%esp
8010438e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104392:	75 a4                	jne    80104338 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104394:	83 ec 08             	sub    $0x8,%esp
80104397:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010439a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010439d:	50                   	push   %eax
8010439e:	8b 43 b0             	mov    -0x50(%ebx),%eax
801043a1:	8b 40 0c             	mov    0xc(%eax),%eax
801043a4:	83 c0 08             	add    $0x8,%eax
801043a7:	50                   	push   %eax
801043a8:	e8 83 01 00 00       	call   80104530 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801043ad:	83 c4 10             	add    $0x10,%esp
801043b0:	8b 17                	mov    (%edi),%edx
801043b2:	85 d2                	test   %edx,%edx
801043b4:	74 82                	je     80104338 <procdump+0x18>
        cprintf(" %p", pc[i]);
801043b6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801043b9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801043bc:	52                   	push   %edx
801043bd:	68 c1 86 10 80       	push   $0x801086c1
801043c2:	e8 d9 c2 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801043c7:	83 c4 10             	add    $0x10,%esp
801043ca:	39 fe                	cmp    %edi,%esi
801043cc:	75 e2                	jne    801043b0 <procdump+0x90>
801043ce:	e9 65 ff ff ff       	jmp    80104338 <procdump+0x18>
801043d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043d7:	90                   	nop
  }
}
801043d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043db:	5b                   	pop    %ebx
801043dc:	5e                   	pop    %esi
801043dd:	5f                   	pop    %edi
801043de:	5d                   	pop    %ebp
801043df:	c3                   	ret    

801043e0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	53                   	push   %ebx
801043e4:	83 ec 0c             	sub    $0xc,%esp
801043e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801043ea:	68 fc 8c 10 80       	push   $0x80108cfc
801043ef:	8d 43 04             	lea    0x4(%ebx),%eax
801043f2:	50                   	push   %eax
801043f3:	e8 18 01 00 00       	call   80104510 <initlock>
  lk->name = name;
801043f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801043fb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104401:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104404:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010440b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010440e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104411:	c9                   	leave  
80104412:	c3                   	ret    
80104413:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010441a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104420 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	56                   	push   %esi
80104424:	53                   	push   %ebx
80104425:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104428:	8d 73 04             	lea    0x4(%ebx),%esi
8010442b:	83 ec 0c             	sub    $0xc,%esp
8010442e:	56                   	push   %esi
8010442f:	e8 ac 02 00 00       	call   801046e0 <acquire>
  while (lk->locked) {
80104434:	8b 13                	mov    (%ebx),%edx
80104436:	83 c4 10             	add    $0x10,%esp
80104439:	85 d2                	test   %edx,%edx
8010443b:	74 16                	je     80104453 <acquiresleep+0x33>
8010443d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104440:	83 ec 08             	sub    $0x8,%esp
80104443:	56                   	push   %esi
80104444:	53                   	push   %ebx
80104445:	e8 36 fd ff ff       	call   80104180 <sleep>
  while (lk->locked) {
8010444a:	8b 03                	mov    (%ebx),%eax
8010444c:	83 c4 10             	add    $0x10,%esp
8010444f:	85 c0                	test   %eax,%eax
80104451:	75 ed                	jne    80104440 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104453:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104459:	e8 82 f5 ff ff       	call   801039e0 <myproc>
8010445e:	8b 40 10             	mov    0x10(%eax),%eax
80104461:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104464:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104467:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010446a:	5b                   	pop    %ebx
8010446b:	5e                   	pop    %esi
8010446c:	5d                   	pop    %ebp
  release(&lk->lk);
8010446d:	e9 0e 02 00 00       	jmp    80104680 <release>
80104472:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104480 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	56                   	push   %esi
80104484:	53                   	push   %ebx
80104485:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104488:	8d 73 04             	lea    0x4(%ebx),%esi
8010448b:	83 ec 0c             	sub    $0xc,%esp
8010448e:	56                   	push   %esi
8010448f:	e8 4c 02 00 00       	call   801046e0 <acquire>
  lk->locked = 0;
80104494:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010449a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801044a1:	89 1c 24             	mov    %ebx,(%esp)
801044a4:	e8 97 fd ff ff       	call   80104240 <wakeup>
  release(&lk->lk);
801044a9:	89 75 08             	mov    %esi,0x8(%ebp)
801044ac:	83 c4 10             	add    $0x10,%esp
}
801044af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044b2:	5b                   	pop    %ebx
801044b3:	5e                   	pop    %esi
801044b4:	5d                   	pop    %ebp
  release(&lk->lk);
801044b5:	e9 c6 01 00 00       	jmp    80104680 <release>
801044ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044c0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	57                   	push   %edi
801044c4:	31 ff                	xor    %edi,%edi
801044c6:	56                   	push   %esi
801044c7:	53                   	push   %ebx
801044c8:	83 ec 18             	sub    $0x18,%esp
801044cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801044ce:	8d 73 04             	lea    0x4(%ebx),%esi
801044d1:	56                   	push   %esi
801044d2:	e8 09 02 00 00       	call   801046e0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801044d7:	8b 03                	mov    (%ebx),%eax
801044d9:	83 c4 10             	add    $0x10,%esp
801044dc:	85 c0                	test   %eax,%eax
801044de:	75 18                	jne    801044f8 <holdingsleep+0x38>
  release(&lk->lk);
801044e0:	83 ec 0c             	sub    $0xc,%esp
801044e3:	56                   	push   %esi
801044e4:	e8 97 01 00 00       	call   80104680 <release>
  return r;
}
801044e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044ec:	89 f8                	mov    %edi,%eax
801044ee:	5b                   	pop    %ebx
801044ef:	5e                   	pop    %esi
801044f0:	5f                   	pop    %edi
801044f1:	5d                   	pop    %ebp
801044f2:	c3                   	ret    
801044f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044f7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
801044f8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801044fb:	e8 e0 f4 ff ff       	call   801039e0 <myproc>
80104500:	39 58 10             	cmp    %ebx,0x10(%eax)
80104503:	0f 94 c0             	sete   %al
80104506:	0f b6 c0             	movzbl %al,%eax
80104509:	89 c7                	mov    %eax,%edi
8010450b:	eb d3                	jmp    801044e0 <holdingsleep+0x20>
8010450d:	66 90                	xchg   %ax,%ax
8010450f:	90                   	nop

80104510 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104516:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104519:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010451f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104522:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104529:	5d                   	pop    %ebp
8010452a:	c3                   	ret    
8010452b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010452f:	90                   	nop

80104530 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104530:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104531:	31 d2                	xor    %edx,%edx
{
80104533:	89 e5                	mov    %esp,%ebp
80104535:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104536:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104539:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010453c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010453f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104540:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104546:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010454c:	77 1a                	ja     80104568 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010454e:	8b 58 04             	mov    0x4(%eax),%ebx
80104551:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104554:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104557:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104559:	83 fa 0a             	cmp    $0xa,%edx
8010455c:	75 e2                	jne    80104540 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010455e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104561:	c9                   	leave  
80104562:	c3                   	ret    
80104563:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104567:	90                   	nop
  for(; i < 10; i++)
80104568:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010456b:	8d 51 28             	lea    0x28(%ecx),%edx
8010456e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104570:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104576:	83 c0 04             	add    $0x4,%eax
80104579:	39 d0                	cmp    %edx,%eax
8010457b:	75 f3                	jne    80104570 <getcallerpcs+0x40>
}
8010457d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104580:	c9                   	leave  
80104581:	c3                   	ret    
80104582:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104590 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	53                   	push   %ebx
80104594:	83 ec 04             	sub    $0x4,%esp
80104597:	9c                   	pushf  
80104598:	5b                   	pop    %ebx
  asm volatile("cli");
80104599:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010459a:	e8 c1 f3 ff ff       	call   80103960 <mycpu>
8010459f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801045a5:	85 c0                	test   %eax,%eax
801045a7:	74 17                	je     801045c0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801045a9:	e8 b2 f3 ff ff       	call   80103960 <mycpu>
801045ae:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801045b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045b8:	c9                   	leave  
801045b9:	c3                   	ret    
801045ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801045c0:	e8 9b f3 ff ff       	call   80103960 <mycpu>
801045c5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801045cb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801045d1:	eb d6                	jmp    801045a9 <pushcli+0x19>
801045d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045e0 <popcli>:

void
popcli(void)
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801045e6:	9c                   	pushf  
801045e7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801045e8:	f6 c4 02             	test   $0x2,%ah
801045eb:	75 35                	jne    80104622 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801045ed:	e8 6e f3 ff ff       	call   80103960 <mycpu>
801045f2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801045f9:	78 34                	js     8010462f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801045fb:	e8 60 f3 ff ff       	call   80103960 <mycpu>
80104600:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104606:	85 d2                	test   %edx,%edx
80104608:	74 06                	je     80104610 <popcli+0x30>
    sti();
}
8010460a:	c9                   	leave  
8010460b:	c3                   	ret    
8010460c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104610:	e8 4b f3 ff ff       	call   80103960 <mycpu>
80104615:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010461b:	85 c0                	test   %eax,%eax
8010461d:	74 eb                	je     8010460a <popcli+0x2a>
  asm volatile("sti");
8010461f:	fb                   	sti    
}
80104620:	c9                   	leave  
80104621:	c3                   	ret    
    panic("popcli - interruptible");
80104622:	83 ec 0c             	sub    $0xc,%esp
80104625:	68 07 8d 10 80       	push   $0x80108d07
8010462a:	e8 51 bd ff ff       	call   80100380 <panic>
    panic("popcli");
8010462f:	83 ec 0c             	sub    $0xc,%esp
80104632:	68 1e 8d 10 80       	push   $0x80108d1e
80104637:	e8 44 bd ff ff       	call   80100380 <panic>
8010463c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104640 <holding>:
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	56                   	push   %esi
80104644:	53                   	push   %ebx
80104645:	8b 75 08             	mov    0x8(%ebp),%esi
80104648:	31 db                	xor    %ebx,%ebx
  pushcli();
8010464a:	e8 41 ff ff ff       	call   80104590 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010464f:	8b 06                	mov    (%esi),%eax
80104651:	85 c0                	test   %eax,%eax
80104653:	75 0b                	jne    80104660 <holding+0x20>
  popcli();
80104655:	e8 86 ff ff ff       	call   801045e0 <popcli>
}
8010465a:	89 d8                	mov    %ebx,%eax
8010465c:	5b                   	pop    %ebx
8010465d:	5e                   	pop    %esi
8010465e:	5d                   	pop    %ebp
8010465f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104660:	8b 5e 08             	mov    0x8(%esi),%ebx
80104663:	e8 f8 f2 ff ff       	call   80103960 <mycpu>
80104668:	39 c3                	cmp    %eax,%ebx
8010466a:	0f 94 c3             	sete   %bl
  popcli();
8010466d:	e8 6e ff ff ff       	call   801045e0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104672:	0f b6 db             	movzbl %bl,%ebx
}
80104675:	89 d8                	mov    %ebx,%eax
80104677:	5b                   	pop    %ebx
80104678:	5e                   	pop    %esi
80104679:	5d                   	pop    %ebp
8010467a:	c3                   	ret    
8010467b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010467f:	90                   	nop

80104680 <release>:
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	56                   	push   %esi
80104684:	53                   	push   %ebx
80104685:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104688:	e8 03 ff ff ff       	call   80104590 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010468d:	8b 03                	mov    (%ebx),%eax
8010468f:	85 c0                	test   %eax,%eax
80104691:	75 15                	jne    801046a8 <release+0x28>
  popcli();
80104693:	e8 48 ff ff ff       	call   801045e0 <popcli>
    panic("release");
80104698:	83 ec 0c             	sub    $0xc,%esp
8010469b:	68 25 8d 10 80       	push   $0x80108d25
801046a0:	e8 db bc ff ff       	call   80100380 <panic>
801046a5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801046a8:	8b 73 08             	mov    0x8(%ebx),%esi
801046ab:	e8 b0 f2 ff ff       	call   80103960 <mycpu>
801046b0:	39 c6                	cmp    %eax,%esi
801046b2:	75 df                	jne    80104693 <release+0x13>
  popcli();
801046b4:	e8 27 ff ff ff       	call   801045e0 <popcli>
  lk->pcs[0] = 0;
801046b9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801046c0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801046c7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801046cc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801046d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046d5:	5b                   	pop    %ebx
801046d6:	5e                   	pop    %esi
801046d7:	5d                   	pop    %ebp
  popcli();
801046d8:	e9 03 ff ff ff       	jmp    801045e0 <popcli>
801046dd:	8d 76 00             	lea    0x0(%esi),%esi

801046e0 <acquire>:
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	53                   	push   %ebx
801046e4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801046e7:	e8 a4 fe ff ff       	call   80104590 <pushcli>
  if(holding(lk))
801046ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801046ef:	e8 9c fe ff ff       	call   80104590 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801046f4:	8b 03                	mov    (%ebx),%eax
801046f6:	85 c0                	test   %eax,%eax
801046f8:	75 7e                	jne    80104778 <acquire+0x98>
  popcli();
801046fa:	e8 e1 fe ff ff       	call   801045e0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801046ff:	b9 01 00 00 00       	mov    $0x1,%ecx
80104704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104708:	8b 55 08             	mov    0x8(%ebp),%edx
8010470b:	89 c8                	mov    %ecx,%eax
8010470d:	f0 87 02             	lock xchg %eax,(%edx)
80104710:	85 c0                	test   %eax,%eax
80104712:	75 f4                	jne    80104708 <acquire+0x28>
  __sync_synchronize();
80104714:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104719:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010471c:	e8 3f f2 ff ff       	call   80103960 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104721:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104724:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104726:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104729:	31 c0                	xor    %eax,%eax
8010472b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010472f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104730:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104736:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010473c:	77 1a                	ja     80104758 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010473e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104741:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104745:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104748:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010474a:	83 f8 0a             	cmp    $0xa,%eax
8010474d:	75 e1                	jne    80104730 <acquire+0x50>
}
8010474f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104752:	c9                   	leave  
80104753:	c3                   	ret    
80104754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104758:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010475c:	8d 51 34             	lea    0x34(%ecx),%edx
8010475f:	90                   	nop
    pcs[i] = 0;
80104760:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104766:	83 c0 04             	add    $0x4,%eax
80104769:	39 c2                	cmp    %eax,%edx
8010476b:	75 f3                	jne    80104760 <acquire+0x80>
}
8010476d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104770:	c9                   	leave  
80104771:	c3                   	ret    
80104772:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104778:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010477b:	e8 e0 f1 ff ff       	call   80103960 <mycpu>
80104780:	39 c3                	cmp    %eax,%ebx
80104782:	0f 85 72 ff ff ff    	jne    801046fa <acquire+0x1a>
  popcli();
80104788:	e8 53 fe ff ff       	call   801045e0 <popcli>
    panic("acquire");
8010478d:	83 ec 0c             	sub    $0xc,%esp
80104790:	68 2d 8d 10 80       	push   $0x80108d2d
80104795:	e8 e6 bb ff ff       	call   80100380 <panic>
8010479a:	66 90                	xchg   %ax,%ax
8010479c:	66 90                	xchg   %ax,%ax
8010479e:	66 90                	xchg   %ax,%ax

801047a0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	57                   	push   %edi
801047a4:	8b 55 08             	mov    0x8(%ebp),%edx
801047a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801047aa:	53                   	push   %ebx
801047ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801047ae:	89 d7                	mov    %edx,%edi
801047b0:	09 cf                	or     %ecx,%edi
801047b2:	83 e7 03             	and    $0x3,%edi
801047b5:	75 29                	jne    801047e0 <memset+0x40>
    c &= 0xFF;
801047b7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801047ba:	c1 e0 18             	shl    $0x18,%eax
801047bd:	89 fb                	mov    %edi,%ebx
801047bf:	c1 e9 02             	shr    $0x2,%ecx
801047c2:	c1 e3 10             	shl    $0x10,%ebx
801047c5:	09 d8                	or     %ebx,%eax
801047c7:	09 f8                	or     %edi,%eax
801047c9:	c1 e7 08             	shl    $0x8,%edi
801047cc:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801047ce:	89 d7                	mov    %edx,%edi
801047d0:	fc                   	cld    
801047d1:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801047d3:	5b                   	pop    %ebx
801047d4:	89 d0                	mov    %edx,%eax
801047d6:	5f                   	pop    %edi
801047d7:	5d                   	pop    %ebp
801047d8:	c3                   	ret    
801047d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801047e0:	89 d7                	mov    %edx,%edi
801047e2:	fc                   	cld    
801047e3:	f3 aa                	rep stos %al,%es:(%edi)
801047e5:	5b                   	pop    %ebx
801047e6:	89 d0                	mov    %edx,%eax
801047e8:	5f                   	pop    %edi
801047e9:	5d                   	pop    %ebp
801047ea:	c3                   	ret    
801047eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047ef:	90                   	nop

801047f0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	56                   	push   %esi
801047f4:	8b 75 10             	mov    0x10(%ebp),%esi
801047f7:	8b 55 08             	mov    0x8(%ebp),%edx
801047fa:	53                   	push   %ebx
801047fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801047fe:	85 f6                	test   %esi,%esi
80104800:	74 2e                	je     80104830 <memcmp+0x40>
80104802:	01 c6                	add    %eax,%esi
80104804:	eb 14                	jmp    8010481a <memcmp+0x2a>
80104806:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010480d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104810:	83 c0 01             	add    $0x1,%eax
80104813:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104816:	39 f0                	cmp    %esi,%eax
80104818:	74 16                	je     80104830 <memcmp+0x40>
    if(*s1 != *s2)
8010481a:	0f b6 0a             	movzbl (%edx),%ecx
8010481d:	0f b6 18             	movzbl (%eax),%ebx
80104820:	38 d9                	cmp    %bl,%cl
80104822:	74 ec                	je     80104810 <memcmp+0x20>
      return *s1 - *s2;
80104824:	0f b6 c1             	movzbl %cl,%eax
80104827:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104829:	5b                   	pop    %ebx
8010482a:	5e                   	pop    %esi
8010482b:	5d                   	pop    %ebp
8010482c:	c3                   	ret    
8010482d:	8d 76 00             	lea    0x0(%esi),%esi
80104830:	5b                   	pop    %ebx
  return 0;
80104831:	31 c0                	xor    %eax,%eax
}
80104833:	5e                   	pop    %esi
80104834:	5d                   	pop    %ebp
80104835:	c3                   	ret    
80104836:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010483d:	8d 76 00             	lea    0x0(%esi),%esi

80104840 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	57                   	push   %edi
80104844:	8b 55 08             	mov    0x8(%ebp),%edx
80104847:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010484a:	56                   	push   %esi
8010484b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010484e:	39 d6                	cmp    %edx,%esi
80104850:	73 26                	jae    80104878 <memmove+0x38>
80104852:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104855:	39 fa                	cmp    %edi,%edx
80104857:	73 1f                	jae    80104878 <memmove+0x38>
80104859:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
8010485c:	85 c9                	test   %ecx,%ecx
8010485e:	74 0c                	je     8010486c <memmove+0x2c>
      *--d = *--s;
80104860:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104864:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104867:	83 e8 01             	sub    $0x1,%eax
8010486a:	73 f4                	jae    80104860 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010486c:	5e                   	pop    %esi
8010486d:	89 d0                	mov    %edx,%eax
8010486f:	5f                   	pop    %edi
80104870:	5d                   	pop    %ebp
80104871:	c3                   	ret    
80104872:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104878:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010487b:	89 d7                	mov    %edx,%edi
8010487d:	85 c9                	test   %ecx,%ecx
8010487f:	74 eb                	je     8010486c <memmove+0x2c>
80104881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104888:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104889:	39 c6                	cmp    %eax,%esi
8010488b:	75 fb                	jne    80104888 <memmove+0x48>
}
8010488d:	5e                   	pop    %esi
8010488e:	89 d0                	mov    %edx,%eax
80104890:	5f                   	pop    %edi
80104891:	5d                   	pop    %ebp
80104892:	c3                   	ret    
80104893:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010489a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048a0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801048a0:	eb 9e                	jmp    80104840 <memmove>
801048a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801048b0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	56                   	push   %esi
801048b4:	8b 75 10             	mov    0x10(%ebp),%esi
801048b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801048ba:	53                   	push   %ebx
801048bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
801048be:	85 f6                	test   %esi,%esi
801048c0:	74 2e                	je     801048f0 <strncmp+0x40>
801048c2:	01 d6                	add    %edx,%esi
801048c4:	eb 18                	jmp    801048de <strncmp+0x2e>
801048c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048cd:	8d 76 00             	lea    0x0(%esi),%esi
801048d0:	38 d8                	cmp    %bl,%al
801048d2:	75 14                	jne    801048e8 <strncmp+0x38>
    n--, p++, q++;
801048d4:	83 c2 01             	add    $0x1,%edx
801048d7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801048da:	39 f2                	cmp    %esi,%edx
801048dc:	74 12                	je     801048f0 <strncmp+0x40>
801048de:	0f b6 01             	movzbl (%ecx),%eax
801048e1:	0f b6 1a             	movzbl (%edx),%ebx
801048e4:	84 c0                	test   %al,%al
801048e6:	75 e8                	jne    801048d0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801048e8:	29 d8                	sub    %ebx,%eax
}
801048ea:	5b                   	pop    %ebx
801048eb:	5e                   	pop    %esi
801048ec:	5d                   	pop    %ebp
801048ed:	c3                   	ret    
801048ee:	66 90                	xchg   %ax,%ax
801048f0:	5b                   	pop    %ebx
    return 0;
801048f1:	31 c0                	xor    %eax,%eax
}
801048f3:	5e                   	pop    %esi
801048f4:	5d                   	pop    %ebp
801048f5:	c3                   	ret    
801048f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048fd:	8d 76 00             	lea    0x0(%esi),%esi

80104900 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	57                   	push   %edi
80104904:	56                   	push   %esi
80104905:	8b 75 08             	mov    0x8(%ebp),%esi
80104908:	53                   	push   %ebx
80104909:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010490c:	89 f0                	mov    %esi,%eax
8010490e:	eb 15                	jmp    80104925 <strncpy+0x25>
80104910:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104914:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104917:	83 c0 01             	add    $0x1,%eax
8010491a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
8010491e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104921:	84 d2                	test   %dl,%dl
80104923:	74 09                	je     8010492e <strncpy+0x2e>
80104925:	89 cb                	mov    %ecx,%ebx
80104927:	83 e9 01             	sub    $0x1,%ecx
8010492a:	85 db                	test   %ebx,%ebx
8010492c:	7f e2                	jg     80104910 <strncpy+0x10>
    ;
  while(n-- > 0)
8010492e:	89 c2                	mov    %eax,%edx
80104930:	85 c9                	test   %ecx,%ecx
80104932:	7e 17                	jle    8010494b <strncpy+0x4b>
80104934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104938:	83 c2 01             	add    $0x1,%edx
8010493b:	89 c1                	mov    %eax,%ecx
8010493d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104941:	29 d1                	sub    %edx,%ecx
80104943:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104947:	85 c9                	test   %ecx,%ecx
80104949:	7f ed                	jg     80104938 <strncpy+0x38>
  return os;
}
8010494b:	5b                   	pop    %ebx
8010494c:	89 f0                	mov    %esi,%eax
8010494e:	5e                   	pop    %esi
8010494f:	5f                   	pop    %edi
80104950:	5d                   	pop    %ebp
80104951:	c3                   	ret    
80104952:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104960 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	56                   	push   %esi
80104964:	8b 55 10             	mov    0x10(%ebp),%edx
80104967:	8b 75 08             	mov    0x8(%ebp),%esi
8010496a:	53                   	push   %ebx
8010496b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010496e:	85 d2                	test   %edx,%edx
80104970:	7e 25                	jle    80104997 <safestrcpy+0x37>
80104972:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104976:	89 f2                	mov    %esi,%edx
80104978:	eb 16                	jmp    80104990 <safestrcpy+0x30>
8010497a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104980:	0f b6 08             	movzbl (%eax),%ecx
80104983:	83 c0 01             	add    $0x1,%eax
80104986:	83 c2 01             	add    $0x1,%edx
80104989:	88 4a ff             	mov    %cl,-0x1(%edx)
8010498c:	84 c9                	test   %cl,%cl
8010498e:	74 04                	je     80104994 <safestrcpy+0x34>
80104990:	39 d8                	cmp    %ebx,%eax
80104992:	75 ec                	jne    80104980 <safestrcpy+0x20>
    ;
  *s = 0;
80104994:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104997:	89 f0                	mov    %esi,%eax
80104999:	5b                   	pop    %ebx
8010499a:	5e                   	pop    %esi
8010499b:	5d                   	pop    %ebp
8010499c:	c3                   	ret    
8010499d:	8d 76 00             	lea    0x0(%esi),%esi

801049a0 <strlen>:

int
strlen(const char *s)
{
801049a0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801049a1:	31 c0                	xor    %eax,%eax
{
801049a3:	89 e5                	mov    %esp,%ebp
801049a5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801049a8:	80 3a 00             	cmpb   $0x0,(%edx)
801049ab:	74 0c                	je     801049b9 <strlen+0x19>
801049ad:	8d 76 00             	lea    0x0(%esi),%esi
801049b0:	83 c0 01             	add    $0x1,%eax
801049b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801049b7:	75 f7                	jne    801049b0 <strlen+0x10>
    ;
  return n;
}
801049b9:	5d                   	pop    %ebp
801049ba:	c3                   	ret    

801049bb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801049bb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801049bf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801049c3:	55                   	push   %ebp
  pushl %ebx
801049c4:	53                   	push   %ebx
  pushl %esi
801049c5:	56                   	push   %esi
  pushl %edi
801049c6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801049c7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801049c9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801049cb:	5f                   	pop    %edi
  popl %esi
801049cc:	5e                   	pop    %esi
  popl %ebx
801049cd:	5b                   	pop    %ebx
  popl %ebp
801049ce:	5d                   	pop    %ebp
  ret
801049cf:	c3                   	ret    

801049d0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	53                   	push   %ebx
801049d4:	83 ec 04             	sub    $0x4,%esp
801049d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801049da:	e8 01 f0 ff ff       	call   801039e0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049df:	8b 00                	mov    (%eax),%eax
801049e1:	39 d8                	cmp    %ebx,%eax
801049e3:	76 1b                	jbe    80104a00 <fetchint+0x30>
801049e5:	8d 53 04             	lea    0x4(%ebx),%edx
801049e8:	39 d0                	cmp    %edx,%eax
801049ea:	72 14                	jb     80104a00 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801049ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801049ef:	8b 13                	mov    (%ebx),%edx
801049f1:	89 10                	mov    %edx,(%eax)
  return 0;
801049f3:	31 c0                	xor    %eax,%eax
}
801049f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049f8:	c9                   	leave  
801049f9:	c3                   	ret    
801049fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104a00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a05:	eb ee                	jmp    801049f5 <fetchint+0x25>
80104a07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a0e:	66 90                	xchg   %ax,%ax

80104a10 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	53                   	push   %ebx
80104a14:	83 ec 04             	sub    $0x4,%esp
80104a17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104a1a:	e8 c1 ef ff ff       	call   801039e0 <myproc>

  if(addr >= curproc->sz)
80104a1f:	39 18                	cmp    %ebx,(%eax)
80104a21:	76 2d                	jbe    80104a50 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104a23:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a26:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104a28:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104a2a:	39 d3                	cmp    %edx,%ebx
80104a2c:	73 22                	jae    80104a50 <fetchstr+0x40>
80104a2e:	89 d8                	mov    %ebx,%eax
80104a30:	eb 0d                	jmp    80104a3f <fetchstr+0x2f>
80104a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a38:	83 c0 01             	add    $0x1,%eax
80104a3b:	39 c2                	cmp    %eax,%edx
80104a3d:	76 11                	jbe    80104a50 <fetchstr+0x40>
    if(*s == 0)
80104a3f:	80 38 00             	cmpb   $0x0,(%eax)
80104a42:	75 f4                	jne    80104a38 <fetchstr+0x28>
      return s - *pp;
80104a44:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104a46:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a49:	c9                   	leave  
80104a4a:	c3                   	ret    
80104a4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a4f:	90                   	nop
80104a50:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104a53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a58:	c9                   	leave  
80104a59:	c3                   	ret    
80104a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a60 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	56                   	push   %esi
80104a64:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a65:	e8 76 ef ff ff       	call   801039e0 <myproc>
80104a6a:	8b 55 08             	mov    0x8(%ebp),%edx
80104a6d:	8b 40 18             	mov    0x18(%eax),%eax
80104a70:	8b 40 44             	mov    0x44(%eax),%eax
80104a73:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a76:	e8 65 ef ff ff       	call   801039e0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a7b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a7e:	8b 00                	mov    (%eax),%eax
80104a80:	39 c6                	cmp    %eax,%esi
80104a82:	73 1c                	jae    80104aa0 <argint+0x40>
80104a84:	8d 53 08             	lea    0x8(%ebx),%edx
80104a87:	39 d0                	cmp    %edx,%eax
80104a89:	72 15                	jb     80104aa0 <argint+0x40>
  *ip = *(int*)(addr);
80104a8b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a8e:	8b 53 04             	mov    0x4(%ebx),%edx
80104a91:	89 10                	mov    %edx,(%eax)
  return 0;
80104a93:	31 c0                	xor    %eax,%eax
}
80104a95:	5b                   	pop    %ebx
80104a96:	5e                   	pop    %esi
80104a97:	5d                   	pop    %ebp
80104a98:	c3                   	ret    
80104a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104aa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104aa5:	eb ee                	jmp    80104a95 <argint+0x35>
80104aa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aae:	66 90                	xchg   %ax,%ax

80104ab0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	57                   	push   %edi
80104ab4:	56                   	push   %esi
80104ab5:	53                   	push   %ebx
80104ab6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104ab9:	e8 22 ef ff ff       	call   801039e0 <myproc>
80104abe:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ac0:	e8 1b ef ff ff       	call   801039e0 <myproc>
80104ac5:	8b 55 08             	mov    0x8(%ebp),%edx
80104ac8:	8b 40 18             	mov    0x18(%eax),%eax
80104acb:	8b 40 44             	mov    0x44(%eax),%eax
80104ace:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ad1:	e8 0a ef ff ff       	call   801039e0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ad6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ad9:	8b 00                	mov    (%eax),%eax
80104adb:	39 c7                	cmp    %eax,%edi
80104add:	73 31                	jae    80104b10 <argptr+0x60>
80104adf:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104ae2:	39 c8                	cmp    %ecx,%eax
80104ae4:	72 2a                	jb     80104b10 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ae6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104ae9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104aec:	85 d2                	test   %edx,%edx
80104aee:	78 20                	js     80104b10 <argptr+0x60>
80104af0:	8b 16                	mov    (%esi),%edx
80104af2:	39 c2                	cmp    %eax,%edx
80104af4:	76 1a                	jbe    80104b10 <argptr+0x60>
80104af6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104af9:	01 c3                	add    %eax,%ebx
80104afb:	39 da                	cmp    %ebx,%edx
80104afd:	72 11                	jb     80104b10 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104aff:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b02:	89 02                	mov    %eax,(%edx)
  return 0;
80104b04:	31 c0                	xor    %eax,%eax
}
80104b06:	83 c4 0c             	add    $0xc,%esp
80104b09:	5b                   	pop    %ebx
80104b0a:	5e                   	pop    %esi
80104b0b:	5f                   	pop    %edi
80104b0c:	5d                   	pop    %ebp
80104b0d:	c3                   	ret    
80104b0e:	66 90                	xchg   %ax,%ax
    return -1;
80104b10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b15:	eb ef                	jmp    80104b06 <argptr+0x56>
80104b17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b1e:	66 90                	xchg   %ax,%ax

80104b20 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	56                   	push   %esi
80104b24:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b25:	e8 b6 ee ff ff       	call   801039e0 <myproc>
80104b2a:	8b 55 08             	mov    0x8(%ebp),%edx
80104b2d:	8b 40 18             	mov    0x18(%eax),%eax
80104b30:	8b 40 44             	mov    0x44(%eax),%eax
80104b33:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b36:	e8 a5 ee ff ff       	call   801039e0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b3b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b3e:	8b 00                	mov    (%eax),%eax
80104b40:	39 c6                	cmp    %eax,%esi
80104b42:	73 44                	jae    80104b88 <argstr+0x68>
80104b44:	8d 53 08             	lea    0x8(%ebx),%edx
80104b47:	39 d0                	cmp    %edx,%eax
80104b49:	72 3d                	jb     80104b88 <argstr+0x68>
  *ip = *(int*)(addr);
80104b4b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104b4e:	e8 8d ee ff ff       	call   801039e0 <myproc>
  if(addr >= curproc->sz)
80104b53:	3b 18                	cmp    (%eax),%ebx
80104b55:	73 31                	jae    80104b88 <argstr+0x68>
  *pp = (char*)addr;
80104b57:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b5a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104b5c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104b5e:	39 d3                	cmp    %edx,%ebx
80104b60:	73 26                	jae    80104b88 <argstr+0x68>
80104b62:	89 d8                	mov    %ebx,%eax
80104b64:	eb 11                	jmp    80104b77 <argstr+0x57>
80104b66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b6d:	8d 76 00             	lea    0x0(%esi),%esi
80104b70:	83 c0 01             	add    $0x1,%eax
80104b73:	39 c2                	cmp    %eax,%edx
80104b75:	76 11                	jbe    80104b88 <argstr+0x68>
    if(*s == 0)
80104b77:	80 38 00             	cmpb   $0x0,(%eax)
80104b7a:	75 f4                	jne    80104b70 <argstr+0x50>
      return s - *pp;
80104b7c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104b7e:	5b                   	pop    %ebx
80104b7f:	5e                   	pop    %esi
80104b80:	5d                   	pop    %ebp
80104b81:	c3                   	ret    
80104b82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b88:	5b                   	pop    %ebx
    return -1;
80104b89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b8e:	5e                   	pop    %esi
80104b8f:	5d                   	pop    %ebp
80104b90:	c3                   	ret    
80104b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b9f:	90                   	nop

80104ba0 <syscall>:
[SYS_getwmapinfo] sys_getwmapinfo,
};

void
syscall(void)
{
80104ba0:	55                   	push   %ebp
80104ba1:	89 e5                	mov    %esp,%ebp
80104ba3:	53                   	push   %ebx
80104ba4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104ba7:	e8 34 ee ff ff       	call   801039e0 <myproc>
80104bac:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104bae:	8b 40 18             	mov    0x18(%eax),%eax
80104bb1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104bb4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104bb7:	83 fa 18             	cmp    $0x18,%edx
80104bba:	77 24                	ja     80104be0 <syscall+0x40>
80104bbc:	8b 14 85 60 8d 10 80 	mov    -0x7fef72a0(,%eax,4),%edx
80104bc3:	85 d2                	test   %edx,%edx
80104bc5:	74 19                	je     80104be0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104bc7:	ff d2                	call   *%edx
80104bc9:	89 c2                	mov    %eax,%edx
80104bcb:	8b 43 18             	mov    0x18(%ebx),%eax
80104bce:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104bd1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bd4:	c9                   	leave  
80104bd5:	c3                   	ret    
80104bd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bdd:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104be0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104be1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104be4:	50                   	push   %eax
80104be5:	ff 73 10             	push   0x10(%ebx)
80104be8:	68 35 8d 10 80       	push   $0x80108d35
80104bed:	e8 ae ba ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104bf2:	8b 43 18             	mov    0x18(%ebx),%eax
80104bf5:	83 c4 10             	add    $0x10,%esp
80104bf8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104bff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c02:	c9                   	leave  
80104c03:	c3                   	ret    
80104c04:	66 90                	xchg   %ax,%ax
80104c06:	66 90                	xchg   %ax,%ax
80104c08:	66 90                	xchg   %ax,%ax
80104c0a:	66 90                	xchg   %ax,%ax
80104c0c:	66 90                	xchg   %ax,%ax
80104c0e:	66 90                	xchg   %ax,%ax

80104c10 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	57                   	push   %edi
80104c14:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104c15:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104c18:	53                   	push   %ebx
80104c19:	83 ec 34             	sub    $0x34,%esp
80104c1c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104c1f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104c22:	57                   	push   %edi
80104c23:	50                   	push   %eax
{
80104c24:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104c27:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104c2a:	e8 a1 d4 ff ff       	call   801020d0 <nameiparent>
80104c2f:	83 c4 10             	add    $0x10,%esp
80104c32:	85 c0                	test   %eax,%eax
80104c34:	0f 84 46 01 00 00    	je     80104d80 <create+0x170>
    return 0;
  ilock(dp);
80104c3a:	83 ec 0c             	sub    $0xc,%esp
80104c3d:	89 c3                	mov    %eax,%ebx
80104c3f:	50                   	push   %eax
80104c40:	e8 4b cb ff ff       	call   80101790 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104c45:	83 c4 0c             	add    $0xc,%esp
80104c48:	6a 00                	push   $0x0
80104c4a:	57                   	push   %edi
80104c4b:	53                   	push   %ebx
80104c4c:	e8 9f d0 ff ff       	call   80101cf0 <dirlookup>
80104c51:	83 c4 10             	add    $0x10,%esp
80104c54:	89 c6                	mov    %eax,%esi
80104c56:	85 c0                	test   %eax,%eax
80104c58:	74 56                	je     80104cb0 <create+0xa0>
    iunlockput(dp);
80104c5a:	83 ec 0c             	sub    $0xc,%esp
80104c5d:	53                   	push   %ebx
80104c5e:	e8 bd cd ff ff       	call   80101a20 <iunlockput>
    ilock(ip);
80104c63:	89 34 24             	mov    %esi,(%esp)
80104c66:	e8 25 cb ff ff       	call   80101790 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104c6b:	83 c4 10             	add    $0x10,%esp
80104c6e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104c73:	75 1b                	jne    80104c90 <create+0x80>
80104c75:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104c7a:	75 14                	jne    80104c90 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104c7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c7f:	89 f0                	mov    %esi,%eax
80104c81:	5b                   	pop    %ebx
80104c82:	5e                   	pop    %esi
80104c83:	5f                   	pop    %edi
80104c84:	5d                   	pop    %ebp
80104c85:	c3                   	ret    
80104c86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c8d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104c90:	83 ec 0c             	sub    $0xc,%esp
80104c93:	56                   	push   %esi
    return 0;
80104c94:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104c96:	e8 85 cd ff ff       	call   80101a20 <iunlockput>
    return 0;
80104c9b:	83 c4 10             	add    $0x10,%esp
}
80104c9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ca1:	89 f0                	mov    %esi,%eax
80104ca3:	5b                   	pop    %ebx
80104ca4:	5e                   	pop    %esi
80104ca5:	5f                   	pop    %edi
80104ca6:	5d                   	pop    %ebp
80104ca7:	c3                   	ret    
80104ca8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104caf:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104cb0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104cb4:	83 ec 08             	sub    $0x8,%esp
80104cb7:	50                   	push   %eax
80104cb8:	ff 33                	push   (%ebx)
80104cba:	e8 61 c9 ff ff       	call   80101620 <ialloc>
80104cbf:	83 c4 10             	add    $0x10,%esp
80104cc2:	89 c6                	mov    %eax,%esi
80104cc4:	85 c0                	test   %eax,%eax
80104cc6:	0f 84 cd 00 00 00    	je     80104d99 <create+0x189>
  ilock(ip);
80104ccc:	83 ec 0c             	sub    $0xc,%esp
80104ccf:	50                   	push   %eax
80104cd0:	e8 bb ca ff ff       	call   80101790 <ilock>
  ip->major = major;
80104cd5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104cd9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104cdd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104ce1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104ce5:	b8 01 00 00 00       	mov    $0x1,%eax
80104cea:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104cee:	89 34 24             	mov    %esi,(%esp)
80104cf1:	e8 ea c9 ff ff       	call   801016e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104cf6:	83 c4 10             	add    $0x10,%esp
80104cf9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104cfe:	74 30                	je     80104d30 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104d00:	83 ec 04             	sub    $0x4,%esp
80104d03:	ff 76 04             	push   0x4(%esi)
80104d06:	57                   	push   %edi
80104d07:	53                   	push   %ebx
80104d08:	e8 e3 d2 ff ff       	call   80101ff0 <dirlink>
80104d0d:	83 c4 10             	add    $0x10,%esp
80104d10:	85 c0                	test   %eax,%eax
80104d12:	78 78                	js     80104d8c <create+0x17c>
  iunlockput(dp);
80104d14:	83 ec 0c             	sub    $0xc,%esp
80104d17:	53                   	push   %ebx
80104d18:	e8 03 cd ff ff       	call   80101a20 <iunlockput>
  return ip;
80104d1d:	83 c4 10             	add    $0x10,%esp
}
80104d20:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d23:	89 f0                	mov    %esi,%eax
80104d25:	5b                   	pop    %ebx
80104d26:	5e                   	pop    %esi
80104d27:	5f                   	pop    %edi
80104d28:	5d                   	pop    %ebp
80104d29:	c3                   	ret    
80104d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104d30:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104d33:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104d38:	53                   	push   %ebx
80104d39:	e8 a2 c9 ff ff       	call   801016e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104d3e:	83 c4 0c             	add    $0xc,%esp
80104d41:	ff 76 04             	push   0x4(%esi)
80104d44:	68 e4 8d 10 80       	push   $0x80108de4
80104d49:	56                   	push   %esi
80104d4a:	e8 a1 d2 ff ff       	call   80101ff0 <dirlink>
80104d4f:	83 c4 10             	add    $0x10,%esp
80104d52:	85 c0                	test   %eax,%eax
80104d54:	78 18                	js     80104d6e <create+0x15e>
80104d56:	83 ec 04             	sub    $0x4,%esp
80104d59:	ff 73 04             	push   0x4(%ebx)
80104d5c:	68 e3 8d 10 80       	push   $0x80108de3
80104d61:	56                   	push   %esi
80104d62:	e8 89 d2 ff ff       	call   80101ff0 <dirlink>
80104d67:	83 c4 10             	add    $0x10,%esp
80104d6a:	85 c0                	test   %eax,%eax
80104d6c:	79 92                	jns    80104d00 <create+0xf0>
      panic("create dots");
80104d6e:	83 ec 0c             	sub    $0xc,%esp
80104d71:	68 d7 8d 10 80       	push   $0x80108dd7
80104d76:	e8 05 b6 ff ff       	call   80100380 <panic>
80104d7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d7f:	90                   	nop
}
80104d80:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104d83:	31 f6                	xor    %esi,%esi
}
80104d85:	5b                   	pop    %ebx
80104d86:	89 f0                	mov    %esi,%eax
80104d88:	5e                   	pop    %esi
80104d89:	5f                   	pop    %edi
80104d8a:	5d                   	pop    %ebp
80104d8b:	c3                   	ret    
    panic("create: dirlink");
80104d8c:	83 ec 0c             	sub    $0xc,%esp
80104d8f:	68 e6 8d 10 80       	push   $0x80108de6
80104d94:	e8 e7 b5 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104d99:	83 ec 0c             	sub    $0xc,%esp
80104d9c:	68 c8 8d 10 80       	push   $0x80108dc8
80104da1:	e8 da b5 ff ff       	call   80100380 <panic>
80104da6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dad:	8d 76 00             	lea    0x0(%esi),%esi

80104db0 <sys_dup>:
{
80104db0:	55                   	push   %ebp
80104db1:	89 e5                	mov    %esp,%ebp
80104db3:	56                   	push   %esi
80104db4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104db5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104db8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104dbb:	50                   	push   %eax
80104dbc:	6a 00                	push   $0x0
80104dbe:	e8 9d fc ff ff       	call   80104a60 <argint>
80104dc3:	83 c4 10             	add    $0x10,%esp
80104dc6:	85 c0                	test   %eax,%eax
80104dc8:	78 36                	js     80104e00 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104dca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104dce:	77 30                	ja     80104e00 <sys_dup+0x50>
80104dd0:	e8 0b ec ff ff       	call   801039e0 <myproc>
80104dd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104dd8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104ddc:	85 f6                	test   %esi,%esi
80104dde:	74 20                	je     80104e00 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104de0:	e8 fb eb ff ff       	call   801039e0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104de5:	31 db                	xor    %ebx,%ebx
80104de7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dee:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104df0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104df4:	85 d2                	test   %edx,%edx
80104df6:	74 18                	je     80104e10 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104df8:	83 c3 01             	add    $0x1,%ebx
80104dfb:	83 fb 10             	cmp    $0x10,%ebx
80104dfe:	75 f0                	jne    80104df0 <sys_dup+0x40>
}
80104e00:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104e03:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104e08:	89 d8                	mov    %ebx,%eax
80104e0a:	5b                   	pop    %ebx
80104e0b:	5e                   	pop    %esi
80104e0c:	5d                   	pop    %ebp
80104e0d:	c3                   	ret    
80104e0e:	66 90                	xchg   %ax,%ax
  filedup(f);
80104e10:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104e13:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104e17:	56                   	push   %esi
80104e18:	e8 93 c0 ff ff       	call   80100eb0 <filedup>
  return fd;
80104e1d:	83 c4 10             	add    $0x10,%esp
}
80104e20:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e23:	89 d8                	mov    %ebx,%eax
80104e25:	5b                   	pop    %ebx
80104e26:	5e                   	pop    %esi
80104e27:	5d                   	pop    %ebp
80104e28:	c3                   	ret    
80104e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104e30 <sys_read>:
{
80104e30:	55                   	push   %ebp
80104e31:	89 e5                	mov    %esp,%ebp
80104e33:	56                   	push   %esi
80104e34:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e35:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104e38:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e3b:	53                   	push   %ebx
80104e3c:	6a 00                	push   $0x0
80104e3e:	e8 1d fc ff ff       	call   80104a60 <argint>
80104e43:	83 c4 10             	add    $0x10,%esp
80104e46:	85 c0                	test   %eax,%eax
80104e48:	78 5e                	js     80104ea8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e4a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e4e:	77 58                	ja     80104ea8 <sys_read+0x78>
80104e50:	e8 8b eb ff ff       	call   801039e0 <myproc>
80104e55:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e58:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104e5c:	85 f6                	test   %esi,%esi
80104e5e:	74 48                	je     80104ea8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e60:	83 ec 08             	sub    $0x8,%esp
80104e63:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e66:	50                   	push   %eax
80104e67:	6a 02                	push   $0x2
80104e69:	e8 f2 fb ff ff       	call   80104a60 <argint>
80104e6e:	83 c4 10             	add    $0x10,%esp
80104e71:	85 c0                	test   %eax,%eax
80104e73:	78 33                	js     80104ea8 <sys_read+0x78>
80104e75:	83 ec 04             	sub    $0x4,%esp
80104e78:	ff 75 f0             	push   -0x10(%ebp)
80104e7b:	53                   	push   %ebx
80104e7c:	6a 01                	push   $0x1
80104e7e:	e8 2d fc ff ff       	call   80104ab0 <argptr>
80104e83:	83 c4 10             	add    $0x10,%esp
80104e86:	85 c0                	test   %eax,%eax
80104e88:	78 1e                	js     80104ea8 <sys_read+0x78>
  return fileread(f, p, n);
80104e8a:	83 ec 04             	sub    $0x4,%esp
80104e8d:	ff 75 f0             	push   -0x10(%ebp)
80104e90:	ff 75 f4             	push   -0xc(%ebp)
80104e93:	56                   	push   %esi
80104e94:	e8 97 c1 ff ff       	call   80101030 <fileread>
80104e99:	83 c4 10             	add    $0x10,%esp
}
80104e9c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e9f:	5b                   	pop    %ebx
80104ea0:	5e                   	pop    %esi
80104ea1:	5d                   	pop    %ebp
80104ea2:	c3                   	ret    
80104ea3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ea7:	90                   	nop
    return -1;
80104ea8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ead:	eb ed                	jmp    80104e9c <sys_read+0x6c>
80104eaf:	90                   	nop

80104eb0 <sys_write>:
{
80104eb0:	55                   	push   %ebp
80104eb1:	89 e5                	mov    %esp,%ebp
80104eb3:	56                   	push   %esi
80104eb4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104eb5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104eb8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104ebb:	53                   	push   %ebx
80104ebc:	6a 00                	push   $0x0
80104ebe:	e8 9d fb ff ff       	call   80104a60 <argint>
80104ec3:	83 c4 10             	add    $0x10,%esp
80104ec6:	85 c0                	test   %eax,%eax
80104ec8:	78 5e                	js     80104f28 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104eca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ece:	77 58                	ja     80104f28 <sys_write+0x78>
80104ed0:	e8 0b eb ff ff       	call   801039e0 <myproc>
80104ed5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ed8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104edc:	85 f6                	test   %esi,%esi
80104ede:	74 48                	je     80104f28 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ee0:	83 ec 08             	sub    $0x8,%esp
80104ee3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ee6:	50                   	push   %eax
80104ee7:	6a 02                	push   $0x2
80104ee9:	e8 72 fb ff ff       	call   80104a60 <argint>
80104eee:	83 c4 10             	add    $0x10,%esp
80104ef1:	85 c0                	test   %eax,%eax
80104ef3:	78 33                	js     80104f28 <sys_write+0x78>
80104ef5:	83 ec 04             	sub    $0x4,%esp
80104ef8:	ff 75 f0             	push   -0x10(%ebp)
80104efb:	53                   	push   %ebx
80104efc:	6a 01                	push   $0x1
80104efe:	e8 ad fb ff ff       	call   80104ab0 <argptr>
80104f03:	83 c4 10             	add    $0x10,%esp
80104f06:	85 c0                	test   %eax,%eax
80104f08:	78 1e                	js     80104f28 <sys_write+0x78>
  return filewrite(f, p, n);
80104f0a:	83 ec 04             	sub    $0x4,%esp
80104f0d:	ff 75 f0             	push   -0x10(%ebp)
80104f10:	ff 75 f4             	push   -0xc(%ebp)
80104f13:	56                   	push   %esi
80104f14:	e8 a7 c1 ff ff       	call   801010c0 <filewrite>
80104f19:	83 c4 10             	add    $0x10,%esp
}
80104f1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f1f:	5b                   	pop    %ebx
80104f20:	5e                   	pop    %esi
80104f21:	5d                   	pop    %ebp
80104f22:	c3                   	ret    
80104f23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f27:	90                   	nop
    return -1;
80104f28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f2d:	eb ed                	jmp    80104f1c <sys_write+0x6c>
80104f2f:	90                   	nop

80104f30 <sys_close>:
{
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	56                   	push   %esi
80104f34:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f35:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104f38:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f3b:	50                   	push   %eax
80104f3c:	6a 00                	push   $0x0
80104f3e:	e8 1d fb ff ff       	call   80104a60 <argint>
80104f43:	83 c4 10             	add    $0x10,%esp
80104f46:	85 c0                	test   %eax,%eax
80104f48:	78 3e                	js     80104f88 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f4a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f4e:	77 38                	ja     80104f88 <sys_close+0x58>
80104f50:	e8 8b ea ff ff       	call   801039e0 <myproc>
80104f55:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f58:	8d 5a 08             	lea    0x8(%edx),%ebx
80104f5b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80104f5f:	85 f6                	test   %esi,%esi
80104f61:	74 25                	je     80104f88 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80104f63:	e8 78 ea ff ff       	call   801039e0 <myproc>
  fileclose(f);
80104f68:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104f6b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80104f72:	00 
  fileclose(f);
80104f73:	56                   	push   %esi
80104f74:	e8 87 bf ff ff       	call   80100f00 <fileclose>
  return 0;
80104f79:	83 c4 10             	add    $0x10,%esp
80104f7c:	31 c0                	xor    %eax,%eax
}
80104f7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f81:	5b                   	pop    %ebx
80104f82:	5e                   	pop    %esi
80104f83:	5d                   	pop    %ebp
80104f84:	c3                   	ret    
80104f85:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104f88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f8d:	eb ef                	jmp    80104f7e <sys_close+0x4e>
80104f8f:	90                   	nop

80104f90 <sys_fstat>:
{
80104f90:	55                   	push   %ebp
80104f91:	89 e5                	mov    %esp,%ebp
80104f93:	56                   	push   %esi
80104f94:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f95:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104f98:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f9b:	53                   	push   %ebx
80104f9c:	6a 00                	push   $0x0
80104f9e:	e8 bd fa ff ff       	call   80104a60 <argint>
80104fa3:	83 c4 10             	add    $0x10,%esp
80104fa6:	85 c0                	test   %eax,%eax
80104fa8:	78 46                	js     80104ff0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104faa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fae:	77 40                	ja     80104ff0 <sys_fstat+0x60>
80104fb0:	e8 2b ea ff ff       	call   801039e0 <myproc>
80104fb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fb8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104fbc:	85 f6                	test   %esi,%esi
80104fbe:	74 30                	je     80104ff0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104fc0:	83 ec 04             	sub    $0x4,%esp
80104fc3:	6a 14                	push   $0x14
80104fc5:	53                   	push   %ebx
80104fc6:	6a 01                	push   $0x1
80104fc8:	e8 e3 fa ff ff       	call   80104ab0 <argptr>
80104fcd:	83 c4 10             	add    $0x10,%esp
80104fd0:	85 c0                	test   %eax,%eax
80104fd2:	78 1c                	js     80104ff0 <sys_fstat+0x60>
  return filestat(f, st);
80104fd4:	83 ec 08             	sub    $0x8,%esp
80104fd7:	ff 75 f4             	push   -0xc(%ebp)
80104fda:	56                   	push   %esi
80104fdb:	e8 00 c0 ff ff       	call   80100fe0 <filestat>
80104fe0:	83 c4 10             	add    $0x10,%esp
}
80104fe3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fe6:	5b                   	pop    %ebx
80104fe7:	5e                   	pop    %esi
80104fe8:	5d                   	pop    %ebp
80104fe9:	c3                   	ret    
80104fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104ff0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ff5:	eb ec                	jmp    80104fe3 <sys_fstat+0x53>
80104ff7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ffe:	66 90                	xchg   %ax,%ax

80105000 <sys_link>:
{
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	57                   	push   %edi
80105004:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105005:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105008:	53                   	push   %ebx
80105009:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010500c:	50                   	push   %eax
8010500d:	6a 00                	push   $0x0
8010500f:	e8 0c fb ff ff       	call   80104b20 <argstr>
80105014:	83 c4 10             	add    $0x10,%esp
80105017:	85 c0                	test   %eax,%eax
80105019:	0f 88 fb 00 00 00    	js     8010511a <sys_link+0x11a>
8010501f:	83 ec 08             	sub    $0x8,%esp
80105022:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105025:	50                   	push   %eax
80105026:	6a 01                	push   $0x1
80105028:	e8 f3 fa ff ff       	call   80104b20 <argstr>
8010502d:	83 c4 10             	add    $0x10,%esp
80105030:	85 c0                	test   %eax,%eax
80105032:	0f 88 e2 00 00 00    	js     8010511a <sys_link+0x11a>
  begin_op();
80105038:	e8 33 dd ff ff       	call   80102d70 <begin_op>
  if((ip = namei(old)) == 0){
8010503d:	83 ec 0c             	sub    $0xc,%esp
80105040:	ff 75 d4             	push   -0x2c(%ebp)
80105043:	e8 68 d0 ff ff       	call   801020b0 <namei>
80105048:	83 c4 10             	add    $0x10,%esp
8010504b:	89 c3                	mov    %eax,%ebx
8010504d:	85 c0                	test   %eax,%eax
8010504f:	0f 84 e4 00 00 00    	je     80105139 <sys_link+0x139>
  ilock(ip);
80105055:	83 ec 0c             	sub    $0xc,%esp
80105058:	50                   	push   %eax
80105059:	e8 32 c7 ff ff       	call   80101790 <ilock>
  if(ip->type == T_DIR){
8010505e:	83 c4 10             	add    $0x10,%esp
80105061:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105066:	0f 84 b5 00 00 00    	je     80105121 <sys_link+0x121>
  iupdate(ip);
8010506c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010506f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105074:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105077:	53                   	push   %ebx
80105078:	e8 63 c6 ff ff       	call   801016e0 <iupdate>
  iunlock(ip);
8010507d:	89 1c 24             	mov    %ebx,(%esp)
80105080:	e8 eb c7 ff ff       	call   80101870 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105085:	58                   	pop    %eax
80105086:	5a                   	pop    %edx
80105087:	57                   	push   %edi
80105088:	ff 75 d0             	push   -0x30(%ebp)
8010508b:	e8 40 d0 ff ff       	call   801020d0 <nameiparent>
80105090:	83 c4 10             	add    $0x10,%esp
80105093:	89 c6                	mov    %eax,%esi
80105095:	85 c0                	test   %eax,%eax
80105097:	74 5b                	je     801050f4 <sys_link+0xf4>
  ilock(dp);
80105099:	83 ec 0c             	sub    $0xc,%esp
8010509c:	50                   	push   %eax
8010509d:	e8 ee c6 ff ff       	call   80101790 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801050a2:	8b 03                	mov    (%ebx),%eax
801050a4:	83 c4 10             	add    $0x10,%esp
801050a7:	39 06                	cmp    %eax,(%esi)
801050a9:	75 3d                	jne    801050e8 <sys_link+0xe8>
801050ab:	83 ec 04             	sub    $0x4,%esp
801050ae:	ff 73 04             	push   0x4(%ebx)
801050b1:	57                   	push   %edi
801050b2:	56                   	push   %esi
801050b3:	e8 38 cf ff ff       	call   80101ff0 <dirlink>
801050b8:	83 c4 10             	add    $0x10,%esp
801050bb:	85 c0                	test   %eax,%eax
801050bd:	78 29                	js     801050e8 <sys_link+0xe8>
  iunlockput(dp);
801050bf:	83 ec 0c             	sub    $0xc,%esp
801050c2:	56                   	push   %esi
801050c3:	e8 58 c9 ff ff       	call   80101a20 <iunlockput>
  iput(ip);
801050c8:	89 1c 24             	mov    %ebx,(%esp)
801050cb:	e8 f0 c7 ff ff       	call   801018c0 <iput>
  end_op();
801050d0:	e8 0b dd ff ff       	call   80102de0 <end_op>
  return 0;
801050d5:	83 c4 10             	add    $0x10,%esp
801050d8:	31 c0                	xor    %eax,%eax
}
801050da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050dd:	5b                   	pop    %ebx
801050de:	5e                   	pop    %esi
801050df:	5f                   	pop    %edi
801050e0:	5d                   	pop    %ebp
801050e1:	c3                   	ret    
801050e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801050e8:	83 ec 0c             	sub    $0xc,%esp
801050eb:	56                   	push   %esi
801050ec:	e8 2f c9 ff ff       	call   80101a20 <iunlockput>
    goto bad;
801050f1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801050f4:	83 ec 0c             	sub    $0xc,%esp
801050f7:	53                   	push   %ebx
801050f8:	e8 93 c6 ff ff       	call   80101790 <ilock>
  ip->nlink--;
801050fd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105102:	89 1c 24             	mov    %ebx,(%esp)
80105105:	e8 d6 c5 ff ff       	call   801016e0 <iupdate>
  iunlockput(ip);
8010510a:	89 1c 24             	mov    %ebx,(%esp)
8010510d:	e8 0e c9 ff ff       	call   80101a20 <iunlockput>
  end_op();
80105112:	e8 c9 dc ff ff       	call   80102de0 <end_op>
  return -1;
80105117:	83 c4 10             	add    $0x10,%esp
8010511a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010511f:	eb b9                	jmp    801050da <sys_link+0xda>
    iunlockput(ip);
80105121:	83 ec 0c             	sub    $0xc,%esp
80105124:	53                   	push   %ebx
80105125:	e8 f6 c8 ff ff       	call   80101a20 <iunlockput>
    end_op();
8010512a:	e8 b1 dc ff ff       	call   80102de0 <end_op>
    return -1;
8010512f:	83 c4 10             	add    $0x10,%esp
80105132:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105137:	eb a1                	jmp    801050da <sys_link+0xda>
    end_op();
80105139:	e8 a2 dc ff ff       	call   80102de0 <end_op>
    return -1;
8010513e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105143:	eb 95                	jmp    801050da <sys_link+0xda>
80105145:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010514c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105150 <sys_unlink>:
{
80105150:	55                   	push   %ebp
80105151:	89 e5                	mov    %esp,%ebp
80105153:	57                   	push   %edi
80105154:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105155:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105158:	53                   	push   %ebx
80105159:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010515c:	50                   	push   %eax
8010515d:	6a 00                	push   $0x0
8010515f:	e8 bc f9 ff ff       	call   80104b20 <argstr>
80105164:	83 c4 10             	add    $0x10,%esp
80105167:	85 c0                	test   %eax,%eax
80105169:	0f 88 7a 01 00 00    	js     801052e9 <sys_unlink+0x199>
  begin_op();
8010516f:	e8 fc db ff ff       	call   80102d70 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105174:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105177:	83 ec 08             	sub    $0x8,%esp
8010517a:	53                   	push   %ebx
8010517b:	ff 75 c0             	push   -0x40(%ebp)
8010517e:	e8 4d cf ff ff       	call   801020d0 <nameiparent>
80105183:	83 c4 10             	add    $0x10,%esp
80105186:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105189:	85 c0                	test   %eax,%eax
8010518b:	0f 84 62 01 00 00    	je     801052f3 <sys_unlink+0x1a3>
  ilock(dp);
80105191:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105194:	83 ec 0c             	sub    $0xc,%esp
80105197:	57                   	push   %edi
80105198:	e8 f3 c5 ff ff       	call   80101790 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010519d:	58                   	pop    %eax
8010519e:	5a                   	pop    %edx
8010519f:	68 e4 8d 10 80       	push   $0x80108de4
801051a4:	53                   	push   %ebx
801051a5:	e8 26 cb ff ff       	call   80101cd0 <namecmp>
801051aa:	83 c4 10             	add    $0x10,%esp
801051ad:	85 c0                	test   %eax,%eax
801051af:	0f 84 fb 00 00 00    	je     801052b0 <sys_unlink+0x160>
801051b5:	83 ec 08             	sub    $0x8,%esp
801051b8:	68 e3 8d 10 80       	push   $0x80108de3
801051bd:	53                   	push   %ebx
801051be:	e8 0d cb ff ff       	call   80101cd0 <namecmp>
801051c3:	83 c4 10             	add    $0x10,%esp
801051c6:	85 c0                	test   %eax,%eax
801051c8:	0f 84 e2 00 00 00    	je     801052b0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801051ce:	83 ec 04             	sub    $0x4,%esp
801051d1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801051d4:	50                   	push   %eax
801051d5:	53                   	push   %ebx
801051d6:	57                   	push   %edi
801051d7:	e8 14 cb ff ff       	call   80101cf0 <dirlookup>
801051dc:	83 c4 10             	add    $0x10,%esp
801051df:	89 c3                	mov    %eax,%ebx
801051e1:	85 c0                	test   %eax,%eax
801051e3:	0f 84 c7 00 00 00    	je     801052b0 <sys_unlink+0x160>
  ilock(ip);
801051e9:	83 ec 0c             	sub    $0xc,%esp
801051ec:	50                   	push   %eax
801051ed:	e8 9e c5 ff ff       	call   80101790 <ilock>
  if(ip->nlink < 1)
801051f2:	83 c4 10             	add    $0x10,%esp
801051f5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801051fa:	0f 8e 1c 01 00 00    	jle    8010531c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105200:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105205:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105208:	74 66                	je     80105270 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010520a:	83 ec 04             	sub    $0x4,%esp
8010520d:	6a 10                	push   $0x10
8010520f:	6a 00                	push   $0x0
80105211:	57                   	push   %edi
80105212:	e8 89 f5 ff ff       	call   801047a0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105217:	6a 10                	push   $0x10
80105219:	ff 75 c4             	push   -0x3c(%ebp)
8010521c:	57                   	push   %edi
8010521d:	ff 75 b4             	push   -0x4c(%ebp)
80105220:	e8 7b c9 ff ff       	call   80101ba0 <writei>
80105225:	83 c4 20             	add    $0x20,%esp
80105228:	83 f8 10             	cmp    $0x10,%eax
8010522b:	0f 85 de 00 00 00    	jne    8010530f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105231:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105236:	0f 84 94 00 00 00    	je     801052d0 <sys_unlink+0x180>
  iunlockput(dp);
8010523c:	83 ec 0c             	sub    $0xc,%esp
8010523f:	ff 75 b4             	push   -0x4c(%ebp)
80105242:	e8 d9 c7 ff ff       	call   80101a20 <iunlockput>
  ip->nlink--;
80105247:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010524c:	89 1c 24             	mov    %ebx,(%esp)
8010524f:	e8 8c c4 ff ff       	call   801016e0 <iupdate>
  iunlockput(ip);
80105254:	89 1c 24             	mov    %ebx,(%esp)
80105257:	e8 c4 c7 ff ff       	call   80101a20 <iunlockput>
  end_op();
8010525c:	e8 7f db ff ff       	call   80102de0 <end_op>
  return 0;
80105261:	83 c4 10             	add    $0x10,%esp
80105264:	31 c0                	xor    %eax,%eax
}
80105266:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105269:	5b                   	pop    %ebx
8010526a:	5e                   	pop    %esi
8010526b:	5f                   	pop    %edi
8010526c:	5d                   	pop    %ebp
8010526d:	c3                   	ret    
8010526e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105270:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105274:	76 94                	jbe    8010520a <sys_unlink+0xba>
80105276:	be 20 00 00 00       	mov    $0x20,%esi
8010527b:	eb 0b                	jmp    80105288 <sys_unlink+0x138>
8010527d:	8d 76 00             	lea    0x0(%esi),%esi
80105280:	83 c6 10             	add    $0x10,%esi
80105283:	3b 73 58             	cmp    0x58(%ebx),%esi
80105286:	73 82                	jae    8010520a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105288:	6a 10                	push   $0x10
8010528a:	56                   	push   %esi
8010528b:	57                   	push   %edi
8010528c:	53                   	push   %ebx
8010528d:	e8 0e c8 ff ff       	call   80101aa0 <readi>
80105292:	83 c4 10             	add    $0x10,%esp
80105295:	83 f8 10             	cmp    $0x10,%eax
80105298:	75 68                	jne    80105302 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010529a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010529f:	74 df                	je     80105280 <sys_unlink+0x130>
    iunlockput(ip);
801052a1:	83 ec 0c             	sub    $0xc,%esp
801052a4:	53                   	push   %ebx
801052a5:	e8 76 c7 ff ff       	call   80101a20 <iunlockput>
    goto bad;
801052aa:	83 c4 10             	add    $0x10,%esp
801052ad:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801052b0:	83 ec 0c             	sub    $0xc,%esp
801052b3:	ff 75 b4             	push   -0x4c(%ebp)
801052b6:	e8 65 c7 ff ff       	call   80101a20 <iunlockput>
  end_op();
801052bb:	e8 20 db ff ff       	call   80102de0 <end_op>
  return -1;
801052c0:	83 c4 10             	add    $0x10,%esp
801052c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052c8:	eb 9c                	jmp    80105266 <sys_unlink+0x116>
801052ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801052d0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801052d3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801052d6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801052db:	50                   	push   %eax
801052dc:	e8 ff c3 ff ff       	call   801016e0 <iupdate>
801052e1:	83 c4 10             	add    $0x10,%esp
801052e4:	e9 53 ff ff ff       	jmp    8010523c <sys_unlink+0xec>
    return -1;
801052e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052ee:	e9 73 ff ff ff       	jmp    80105266 <sys_unlink+0x116>
    end_op();
801052f3:	e8 e8 da ff ff       	call   80102de0 <end_op>
    return -1;
801052f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052fd:	e9 64 ff ff ff       	jmp    80105266 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105302:	83 ec 0c             	sub    $0xc,%esp
80105305:	68 08 8e 10 80       	push   $0x80108e08
8010530a:	e8 71 b0 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010530f:	83 ec 0c             	sub    $0xc,%esp
80105312:	68 1a 8e 10 80       	push   $0x80108e1a
80105317:	e8 64 b0 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010531c:	83 ec 0c             	sub    $0xc,%esp
8010531f:	68 f6 8d 10 80       	push   $0x80108df6
80105324:	e8 57 b0 ff ff       	call   80100380 <panic>
80105329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105330 <sys_open>:

int
sys_open(void)
{
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
80105333:	57                   	push   %edi
80105334:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105335:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105338:	53                   	push   %ebx
80105339:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010533c:	50                   	push   %eax
8010533d:	6a 00                	push   $0x0
8010533f:	e8 dc f7 ff ff       	call   80104b20 <argstr>
80105344:	83 c4 10             	add    $0x10,%esp
80105347:	85 c0                	test   %eax,%eax
80105349:	0f 88 8e 00 00 00    	js     801053dd <sys_open+0xad>
8010534f:	83 ec 08             	sub    $0x8,%esp
80105352:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105355:	50                   	push   %eax
80105356:	6a 01                	push   $0x1
80105358:	e8 03 f7 ff ff       	call   80104a60 <argint>
8010535d:	83 c4 10             	add    $0x10,%esp
80105360:	85 c0                	test   %eax,%eax
80105362:	78 79                	js     801053dd <sys_open+0xad>
    return -1;

  begin_op();
80105364:	e8 07 da ff ff       	call   80102d70 <begin_op>

  if(omode & O_CREATE){
80105369:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010536d:	75 79                	jne    801053e8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010536f:	83 ec 0c             	sub    $0xc,%esp
80105372:	ff 75 e0             	push   -0x20(%ebp)
80105375:	e8 36 cd ff ff       	call   801020b0 <namei>
8010537a:	83 c4 10             	add    $0x10,%esp
8010537d:	89 c6                	mov    %eax,%esi
8010537f:	85 c0                	test   %eax,%eax
80105381:	0f 84 7e 00 00 00    	je     80105405 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105387:	83 ec 0c             	sub    $0xc,%esp
8010538a:	50                   	push   %eax
8010538b:	e8 00 c4 ff ff       	call   80101790 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105390:	83 c4 10             	add    $0x10,%esp
80105393:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105398:	0f 84 c2 00 00 00    	je     80105460 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010539e:	e8 9d ba ff ff       	call   80100e40 <filealloc>
801053a3:	89 c7                	mov    %eax,%edi
801053a5:	85 c0                	test   %eax,%eax
801053a7:	74 23                	je     801053cc <sys_open+0x9c>
  struct proc *curproc = myproc();
801053a9:	e8 32 e6 ff ff       	call   801039e0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801053ae:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801053b0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801053b4:	85 d2                	test   %edx,%edx
801053b6:	74 60                	je     80105418 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801053b8:	83 c3 01             	add    $0x1,%ebx
801053bb:	83 fb 10             	cmp    $0x10,%ebx
801053be:	75 f0                	jne    801053b0 <sys_open+0x80>
    if(f)
      fileclose(f);
801053c0:	83 ec 0c             	sub    $0xc,%esp
801053c3:	57                   	push   %edi
801053c4:	e8 37 bb ff ff       	call   80100f00 <fileclose>
801053c9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801053cc:	83 ec 0c             	sub    $0xc,%esp
801053cf:	56                   	push   %esi
801053d0:	e8 4b c6 ff ff       	call   80101a20 <iunlockput>
    end_op();
801053d5:	e8 06 da ff ff       	call   80102de0 <end_op>
    return -1;
801053da:	83 c4 10             	add    $0x10,%esp
801053dd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801053e2:	eb 6d                	jmp    80105451 <sys_open+0x121>
801053e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801053e8:	83 ec 0c             	sub    $0xc,%esp
801053eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801053ee:	31 c9                	xor    %ecx,%ecx
801053f0:	ba 02 00 00 00       	mov    $0x2,%edx
801053f5:	6a 00                	push   $0x0
801053f7:	e8 14 f8 ff ff       	call   80104c10 <create>
    if(ip == 0){
801053fc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801053ff:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105401:	85 c0                	test   %eax,%eax
80105403:	75 99                	jne    8010539e <sys_open+0x6e>
      end_op();
80105405:	e8 d6 d9 ff ff       	call   80102de0 <end_op>
      return -1;
8010540a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010540f:	eb 40                	jmp    80105451 <sys_open+0x121>
80105411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105418:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010541b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010541f:	56                   	push   %esi
80105420:	e8 4b c4 ff ff       	call   80101870 <iunlock>
  end_op();
80105425:	e8 b6 d9 ff ff       	call   80102de0 <end_op>

  f->type = FD_INODE;
8010542a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105430:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105433:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105436:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105439:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010543b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105442:	f7 d0                	not    %eax
80105444:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105447:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010544a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010544d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105451:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105454:	89 d8                	mov    %ebx,%eax
80105456:	5b                   	pop    %ebx
80105457:	5e                   	pop    %esi
80105458:	5f                   	pop    %edi
80105459:	5d                   	pop    %ebp
8010545a:	c3                   	ret    
8010545b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010545f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105460:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105463:	85 c9                	test   %ecx,%ecx
80105465:	0f 84 33 ff ff ff    	je     8010539e <sys_open+0x6e>
8010546b:	e9 5c ff ff ff       	jmp    801053cc <sys_open+0x9c>

80105470 <sys_mkdir>:

int
sys_mkdir(void)
{
80105470:	55                   	push   %ebp
80105471:	89 e5                	mov    %esp,%ebp
80105473:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105476:	e8 f5 d8 ff ff       	call   80102d70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010547b:	83 ec 08             	sub    $0x8,%esp
8010547e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105481:	50                   	push   %eax
80105482:	6a 00                	push   $0x0
80105484:	e8 97 f6 ff ff       	call   80104b20 <argstr>
80105489:	83 c4 10             	add    $0x10,%esp
8010548c:	85 c0                	test   %eax,%eax
8010548e:	78 30                	js     801054c0 <sys_mkdir+0x50>
80105490:	83 ec 0c             	sub    $0xc,%esp
80105493:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105496:	31 c9                	xor    %ecx,%ecx
80105498:	ba 01 00 00 00       	mov    $0x1,%edx
8010549d:	6a 00                	push   $0x0
8010549f:	e8 6c f7 ff ff       	call   80104c10 <create>
801054a4:	83 c4 10             	add    $0x10,%esp
801054a7:	85 c0                	test   %eax,%eax
801054a9:	74 15                	je     801054c0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801054ab:	83 ec 0c             	sub    $0xc,%esp
801054ae:	50                   	push   %eax
801054af:	e8 6c c5 ff ff       	call   80101a20 <iunlockput>
  end_op();
801054b4:	e8 27 d9 ff ff       	call   80102de0 <end_op>
  return 0;
801054b9:	83 c4 10             	add    $0x10,%esp
801054bc:	31 c0                	xor    %eax,%eax
}
801054be:	c9                   	leave  
801054bf:	c3                   	ret    
    end_op();
801054c0:	e8 1b d9 ff ff       	call   80102de0 <end_op>
    return -1;
801054c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054ca:	c9                   	leave  
801054cb:	c3                   	ret    
801054cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054d0 <sys_mknod>:

int
sys_mknod(void)
{
801054d0:	55                   	push   %ebp
801054d1:	89 e5                	mov    %esp,%ebp
801054d3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801054d6:	e8 95 d8 ff ff       	call   80102d70 <begin_op>
  if((argstr(0, &path)) < 0 ||
801054db:	83 ec 08             	sub    $0x8,%esp
801054de:	8d 45 ec             	lea    -0x14(%ebp),%eax
801054e1:	50                   	push   %eax
801054e2:	6a 00                	push   $0x0
801054e4:	e8 37 f6 ff ff       	call   80104b20 <argstr>
801054e9:	83 c4 10             	add    $0x10,%esp
801054ec:	85 c0                	test   %eax,%eax
801054ee:	78 60                	js     80105550 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801054f0:	83 ec 08             	sub    $0x8,%esp
801054f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054f6:	50                   	push   %eax
801054f7:	6a 01                	push   $0x1
801054f9:	e8 62 f5 ff ff       	call   80104a60 <argint>
  if((argstr(0, &path)) < 0 ||
801054fe:	83 c4 10             	add    $0x10,%esp
80105501:	85 c0                	test   %eax,%eax
80105503:	78 4b                	js     80105550 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105505:	83 ec 08             	sub    $0x8,%esp
80105508:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010550b:	50                   	push   %eax
8010550c:	6a 02                	push   $0x2
8010550e:	e8 4d f5 ff ff       	call   80104a60 <argint>
     argint(1, &major) < 0 ||
80105513:	83 c4 10             	add    $0x10,%esp
80105516:	85 c0                	test   %eax,%eax
80105518:	78 36                	js     80105550 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010551a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010551e:	83 ec 0c             	sub    $0xc,%esp
80105521:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105525:	ba 03 00 00 00       	mov    $0x3,%edx
8010552a:	50                   	push   %eax
8010552b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010552e:	e8 dd f6 ff ff       	call   80104c10 <create>
     argint(2, &minor) < 0 ||
80105533:	83 c4 10             	add    $0x10,%esp
80105536:	85 c0                	test   %eax,%eax
80105538:	74 16                	je     80105550 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010553a:	83 ec 0c             	sub    $0xc,%esp
8010553d:	50                   	push   %eax
8010553e:	e8 dd c4 ff ff       	call   80101a20 <iunlockput>
  end_op();
80105543:	e8 98 d8 ff ff       	call   80102de0 <end_op>
  return 0;
80105548:	83 c4 10             	add    $0x10,%esp
8010554b:	31 c0                	xor    %eax,%eax
}
8010554d:	c9                   	leave  
8010554e:	c3                   	ret    
8010554f:	90                   	nop
    end_op();
80105550:	e8 8b d8 ff ff       	call   80102de0 <end_op>
    return -1;
80105555:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010555a:	c9                   	leave  
8010555b:	c3                   	ret    
8010555c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105560 <sys_chdir>:

int
sys_chdir(void)
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	56                   	push   %esi
80105564:	53                   	push   %ebx
80105565:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105568:	e8 73 e4 ff ff       	call   801039e0 <myproc>
8010556d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010556f:	e8 fc d7 ff ff       	call   80102d70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105574:	83 ec 08             	sub    $0x8,%esp
80105577:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010557a:	50                   	push   %eax
8010557b:	6a 00                	push   $0x0
8010557d:	e8 9e f5 ff ff       	call   80104b20 <argstr>
80105582:	83 c4 10             	add    $0x10,%esp
80105585:	85 c0                	test   %eax,%eax
80105587:	78 77                	js     80105600 <sys_chdir+0xa0>
80105589:	83 ec 0c             	sub    $0xc,%esp
8010558c:	ff 75 f4             	push   -0xc(%ebp)
8010558f:	e8 1c cb ff ff       	call   801020b0 <namei>
80105594:	83 c4 10             	add    $0x10,%esp
80105597:	89 c3                	mov    %eax,%ebx
80105599:	85 c0                	test   %eax,%eax
8010559b:	74 63                	je     80105600 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010559d:	83 ec 0c             	sub    $0xc,%esp
801055a0:	50                   	push   %eax
801055a1:	e8 ea c1 ff ff       	call   80101790 <ilock>
  if(ip->type != T_DIR){
801055a6:	83 c4 10             	add    $0x10,%esp
801055a9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055ae:	75 30                	jne    801055e0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801055b0:	83 ec 0c             	sub    $0xc,%esp
801055b3:	53                   	push   %ebx
801055b4:	e8 b7 c2 ff ff       	call   80101870 <iunlock>
  iput(curproc->cwd);
801055b9:	58                   	pop    %eax
801055ba:	ff 76 68             	push   0x68(%esi)
801055bd:	e8 fe c2 ff ff       	call   801018c0 <iput>
  end_op();
801055c2:	e8 19 d8 ff ff       	call   80102de0 <end_op>
  curproc->cwd = ip;
801055c7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801055ca:	83 c4 10             	add    $0x10,%esp
801055cd:	31 c0                	xor    %eax,%eax
}
801055cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055d2:	5b                   	pop    %ebx
801055d3:	5e                   	pop    %esi
801055d4:	5d                   	pop    %ebp
801055d5:	c3                   	ret    
801055d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055dd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801055e0:	83 ec 0c             	sub    $0xc,%esp
801055e3:	53                   	push   %ebx
801055e4:	e8 37 c4 ff ff       	call   80101a20 <iunlockput>
    end_op();
801055e9:	e8 f2 d7 ff ff       	call   80102de0 <end_op>
    return -1;
801055ee:	83 c4 10             	add    $0x10,%esp
801055f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055f6:	eb d7                	jmp    801055cf <sys_chdir+0x6f>
801055f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055ff:	90                   	nop
    end_op();
80105600:	e8 db d7 ff ff       	call   80102de0 <end_op>
    return -1;
80105605:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010560a:	eb c3                	jmp    801055cf <sys_chdir+0x6f>
8010560c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105610 <sys_exec>:

int
sys_exec(void)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	57                   	push   %edi
80105614:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105615:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010561b:	53                   	push   %ebx
8010561c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105622:	50                   	push   %eax
80105623:	6a 00                	push   $0x0
80105625:	e8 f6 f4 ff ff       	call   80104b20 <argstr>
8010562a:	83 c4 10             	add    $0x10,%esp
8010562d:	85 c0                	test   %eax,%eax
8010562f:	0f 88 87 00 00 00    	js     801056bc <sys_exec+0xac>
80105635:	83 ec 08             	sub    $0x8,%esp
80105638:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010563e:	50                   	push   %eax
8010563f:	6a 01                	push   $0x1
80105641:	e8 1a f4 ff ff       	call   80104a60 <argint>
80105646:	83 c4 10             	add    $0x10,%esp
80105649:	85 c0                	test   %eax,%eax
8010564b:	78 6f                	js     801056bc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010564d:	83 ec 04             	sub    $0x4,%esp
80105650:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105656:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105658:	68 80 00 00 00       	push   $0x80
8010565d:	6a 00                	push   $0x0
8010565f:	56                   	push   %esi
80105660:	e8 3b f1 ff ff       	call   801047a0 <memset>
80105665:	83 c4 10             	add    $0x10,%esp
80105668:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010566f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105670:	83 ec 08             	sub    $0x8,%esp
80105673:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105679:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105680:	50                   	push   %eax
80105681:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105687:	01 f8                	add    %edi,%eax
80105689:	50                   	push   %eax
8010568a:	e8 41 f3 ff ff       	call   801049d0 <fetchint>
8010568f:	83 c4 10             	add    $0x10,%esp
80105692:	85 c0                	test   %eax,%eax
80105694:	78 26                	js     801056bc <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105696:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010569c:	85 c0                	test   %eax,%eax
8010569e:	74 30                	je     801056d0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801056a0:	83 ec 08             	sub    $0x8,%esp
801056a3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801056a6:	52                   	push   %edx
801056a7:	50                   	push   %eax
801056a8:	e8 63 f3 ff ff       	call   80104a10 <fetchstr>
801056ad:	83 c4 10             	add    $0x10,%esp
801056b0:	85 c0                	test   %eax,%eax
801056b2:	78 08                	js     801056bc <sys_exec+0xac>
  for(i=0;; i++){
801056b4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801056b7:	83 fb 20             	cmp    $0x20,%ebx
801056ba:	75 b4                	jne    80105670 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801056bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801056bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056c4:	5b                   	pop    %ebx
801056c5:	5e                   	pop    %esi
801056c6:	5f                   	pop    %edi
801056c7:	5d                   	pop    %ebp
801056c8:	c3                   	ret    
801056c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801056d0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801056d7:	00 00 00 00 
  return exec(path, argv);
801056db:	83 ec 08             	sub    $0x8,%esp
801056de:	56                   	push   %esi
801056df:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801056e5:	e8 c6 b3 ff ff       	call   80100ab0 <exec>
801056ea:	83 c4 10             	add    $0x10,%esp
}
801056ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056f0:	5b                   	pop    %ebx
801056f1:	5e                   	pop    %esi
801056f2:	5f                   	pop    %edi
801056f3:	5d                   	pop    %ebp
801056f4:	c3                   	ret    
801056f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105700 <sys_pipe>:

int
sys_pipe(void)
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	57                   	push   %edi
80105704:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105705:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105708:	53                   	push   %ebx
80105709:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010570c:	6a 08                	push   $0x8
8010570e:	50                   	push   %eax
8010570f:	6a 00                	push   $0x0
80105711:	e8 9a f3 ff ff       	call   80104ab0 <argptr>
80105716:	83 c4 10             	add    $0x10,%esp
80105719:	85 c0                	test   %eax,%eax
8010571b:	78 4a                	js     80105767 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010571d:	83 ec 08             	sub    $0x8,%esp
80105720:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105723:	50                   	push   %eax
80105724:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105727:	50                   	push   %eax
80105728:	e8 13 dd ff ff       	call   80103440 <pipealloc>
8010572d:	83 c4 10             	add    $0x10,%esp
80105730:	85 c0                	test   %eax,%eax
80105732:	78 33                	js     80105767 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105734:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105737:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105739:	e8 a2 e2 ff ff       	call   801039e0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010573e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105740:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105744:	85 f6                	test   %esi,%esi
80105746:	74 28                	je     80105770 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105748:	83 c3 01             	add    $0x1,%ebx
8010574b:	83 fb 10             	cmp    $0x10,%ebx
8010574e:	75 f0                	jne    80105740 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105750:	83 ec 0c             	sub    $0xc,%esp
80105753:	ff 75 e0             	push   -0x20(%ebp)
80105756:	e8 a5 b7 ff ff       	call   80100f00 <fileclose>
    fileclose(wf);
8010575b:	58                   	pop    %eax
8010575c:	ff 75 e4             	push   -0x1c(%ebp)
8010575f:	e8 9c b7 ff ff       	call   80100f00 <fileclose>
    return -1;
80105764:	83 c4 10             	add    $0x10,%esp
80105767:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010576c:	eb 53                	jmp    801057c1 <sys_pipe+0xc1>
8010576e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105770:	8d 73 08             	lea    0x8(%ebx),%esi
80105773:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105777:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010577a:	e8 61 e2 ff ff       	call   801039e0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010577f:	31 d2                	xor    %edx,%edx
80105781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105788:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010578c:	85 c9                	test   %ecx,%ecx
8010578e:	74 20                	je     801057b0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105790:	83 c2 01             	add    $0x1,%edx
80105793:	83 fa 10             	cmp    $0x10,%edx
80105796:	75 f0                	jne    80105788 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105798:	e8 43 e2 ff ff       	call   801039e0 <myproc>
8010579d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801057a4:	00 
801057a5:	eb a9                	jmp    80105750 <sys_pipe+0x50>
801057a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ae:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801057b0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801057b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801057b7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801057b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801057bc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801057bf:	31 c0                	xor    %eax,%eax
}
801057c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057c4:	5b                   	pop    %ebx
801057c5:	5e                   	pop    %esi
801057c6:	5f                   	pop    %edi
801057c7:	5d                   	pop    %ebp
801057c8:	c3                   	ret    
801057c9:	66 90                	xchg   %ax,%ax
801057cb:	66 90                	xchg   %ax,%ax
801057cd:	66 90                	xchg   %ax,%ax
801057cf:	90                   	nop

801057d0 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801057d0:	e9 ab e3 ff ff       	jmp    80103b80 <fork>
801057d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057e0 <sys_exit>:
}

int
sys_exit(void)
{
801057e0:	55                   	push   %ebp
801057e1:	89 e5                	mov    %esp,%ebp
801057e3:	83 ec 08             	sub    $0x8,%esp
  exit();
801057e6:	e8 75 e6 ff ff       	call   80103e60 <exit>
  return 0;  // not reached
}
801057eb:	31 c0                	xor    %eax,%eax
801057ed:	c9                   	leave  
801057ee:	c3                   	ret    
801057ef:	90                   	nop

801057f0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801057f0:	e9 0b e8 ff ff       	jmp    80104000 <wait>
801057f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105800 <sys_kill>:
}

int
sys_kill(void)
{
80105800:	55                   	push   %ebp
80105801:	89 e5                	mov    %esp,%ebp
80105803:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105806:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105809:	50                   	push   %eax
8010580a:	6a 00                	push   $0x0
8010580c:	e8 4f f2 ff ff       	call   80104a60 <argint>
80105811:	83 c4 10             	add    $0x10,%esp
80105814:	85 c0                	test   %eax,%eax
80105816:	78 18                	js     80105830 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105818:	83 ec 0c             	sub    $0xc,%esp
8010581b:	ff 75 f4             	push   -0xc(%ebp)
8010581e:	e8 7d ea ff ff       	call   801042a0 <kill>
80105823:	83 c4 10             	add    $0x10,%esp
}
80105826:	c9                   	leave  
80105827:	c3                   	ret    
80105828:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010582f:	90                   	nop
80105830:	c9                   	leave  
    return -1;
80105831:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105836:	c3                   	ret    
80105837:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010583e:	66 90                	xchg   %ax,%ax

80105840 <sys_getpid>:

int
sys_getpid(void)
{
80105840:	55                   	push   %ebp
80105841:	89 e5                	mov    %esp,%ebp
80105843:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105846:	e8 95 e1 ff ff       	call   801039e0 <myproc>
8010584b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010584e:	c9                   	leave  
8010584f:	c3                   	ret    

80105850 <sys_sbrk>:

int
sys_sbrk(void)
{
80105850:	55                   	push   %ebp
80105851:	89 e5                	mov    %esp,%ebp
80105853:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105854:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105857:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010585a:	50                   	push   %eax
8010585b:	6a 00                	push   $0x0
8010585d:	e8 fe f1 ff ff       	call   80104a60 <argint>
80105862:	83 c4 10             	add    $0x10,%esp
80105865:	85 c0                	test   %eax,%eax
80105867:	78 27                	js     80105890 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105869:	e8 72 e1 ff ff       	call   801039e0 <myproc>
  if(growproc(n) < 0)
8010586e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105871:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105873:	ff 75 f4             	push   -0xc(%ebp)
80105876:	e8 85 e2 ff ff       	call   80103b00 <growproc>
8010587b:	83 c4 10             	add    $0x10,%esp
8010587e:	85 c0                	test   %eax,%eax
80105880:	78 0e                	js     80105890 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105882:	89 d8                	mov    %ebx,%eax
80105884:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105887:	c9                   	leave  
80105888:	c3                   	ret    
80105889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105890:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105895:	eb eb                	jmp    80105882 <sys_sbrk+0x32>
80105897:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010589e:	66 90                	xchg   %ax,%ax

801058a0 <sys_sleep>:

int
sys_sleep(void)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801058a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801058a7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801058aa:	50                   	push   %eax
801058ab:	6a 00                	push   $0x0
801058ad:	e8 ae f1 ff ff       	call   80104a60 <argint>
801058b2:	83 c4 10             	add    $0x10,%esp
801058b5:	85 c0                	test   %eax,%eax
801058b7:	0f 88 8a 00 00 00    	js     80105947 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801058bd:	83 ec 0c             	sub    $0xc,%esp
801058c0:	68 a0 ad 21 80       	push   $0x8021ada0
801058c5:	e8 16 ee ff ff       	call   801046e0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801058ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801058cd:	8b 1d 80 ad 21 80    	mov    0x8021ad80,%ebx
  while(ticks - ticks0 < n){
801058d3:	83 c4 10             	add    $0x10,%esp
801058d6:	85 d2                	test   %edx,%edx
801058d8:	75 27                	jne    80105901 <sys_sleep+0x61>
801058da:	eb 54                	jmp    80105930 <sys_sleep+0x90>
801058dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801058e0:	83 ec 08             	sub    $0x8,%esp
801058e3:	68 a0 ad 21 80       	push   $0x8021ada0
801058e8:	68 80 ad 21 80       	push   $0x8021ad80
801058ed:	e8 8e e8 ff ff       	call   80104180 <sleep>
  while(ticks - ticks0 < n){
801058f2:	a1 80 ad 21 80       	mov    0x8021ad80,%eax
801058f7:	83 c4 10             	add    $0x10,%esp
801058fa:	29 d8                	sub    %ebx,%eax
801058fc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801058ff:	73 2f                	jae    80105930 <sys_sleep+0x90>
    if(myproc()->killed){
80105901:	e8 da e0 ff ff       	call   801039e0 <myproc>
80105906:	8b 40 24             	mov    0x24(%eax),%eax
80105909:	85 c0                	test   %eax,%eax
8010590b:	74 d3                	je     801058e0 <sys_sleep+0x40>
      release(&tickslock);
8010590d:	83 ec 0c             	sub    $0xc,%esp
80105910:	68 a0 ad 21 80       	push   $0x8021ada0
80105915:	e8 66 ed ff ff       	call   80104680 <release>
  }
  release(&tickslock);
  return 0;
}
8010591a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010591d:	83 c4 10             	add    $0x10,%esp
80105920:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105925:	c9                   	leave  
80105926:	c3                   	ret    
80105927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010592e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105930:	83 ec 0c             	sub    $0xc,%esp
80105933:	68 a0 ad 21 80       	push   $0x8021ada0
80105938:	e8 43 ed ff ff       	call   80104680 <release>
  return 0;
8010593d:	83 c4 10             	add    $0x10,%esp
80105940:	31 c0                	xor    %eax,%eax
}
80105942:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105945:	c9                   	leave  
80105946:	c3                   	ret    
    return -1;
80105947:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010594c:	eb f4                	jmp    80105942 <sys_sleep+0xa2>
8010594e:	66 90                	xchg   %ax,%ax

80105950 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105950:	55                   	push   %ebp
80105951:	89 e5                	mov    %esp,%ebp
80105953:	53                   	push   %ebx
80105954:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105957:	68 a0 ad 21 80       	push   $0x8021ada0
8010595c:	e8 7f ed ff ff       	call   801046e0 <acquire>
  xticks = ticks;
80105961:	8b 1d 80 ad 21 80    	mov    0x8021ad80,%ebx
  release(&tickslock);
80105967:	c7 04 24 a0 ad 21 80 	movl   $0x8021ada0,(%esp)
8010596e:	e8 0d ed ff ff       	call   80104680 <release>
  return xticks;
}
80105973:	89 d8                	mov    %ebx,%eax
80105975:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105978:	c9                   	leave  
80105979:	c3                   	ret    
8010597a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105980 <sys_wmap>:
// task 1 implementation
extern int DEBUG;

int
sys_wmap(void)
{
80105980:	55                   	push   %ebp
80105981:	89 e5                	mov    %esp,%ebp
80105983:	53                   	push   %ebx
  uint addr;
  int length;
  int flags;
  int fd;

  if(argint(0, (int *) &addr) < 0) return FAILED;
80105984:	8d 45 e8             	lea    -0x18(%ebp),%eax
{
80105987:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, (int *) &addr) < 0) return FAILED;
8010598a:	50                   	push   %eax
8010598b:	6a 00                	push   $0x0
8010598d:	e8 ce f0 ff ff       	call   80104a60 <argint>
80105992:	83 c4 10             	add    $0x10,%esp
80105995:	85 c0                	test   %eax,%eax
80105997:	0f 88 db 00 00 00    	js     80105a78 <sys_wmap+0xf8>
  if(argint(1, &length) < 0) return FAILED;
8010599d:	83 ec 08             	sub    $0x8,%esp
801059a0:	8d 45 ec             	lea    -0x14(%ebp),%eax
801059a3:	50                   	push   %eax
801059a4:	6a 01                	push   $0x1
801059a6:	e8 b5 f0 ff ff       	call   80104a60 <argint>
801059ab:	83 c4 10             	add    $0x10,%esp
801059ae:	85 c0                	test   %eax,%eax
801059b0:	0f 88 c2 00 00 00    	js     80105a78 <sys_wmap+0xf8>
  if(argint(2, &flags) < 0) return FAILED;
801059b6:	83 ec 08             	sub    $0x8,%esp
801059b9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059bc:	50                   	push   %eax
801059bd:	6a 02                	push   $0x2
801059bf:	e8 9c f0 ff ff       	call   80104a60 <argint>
801059c4:	83 c4 10             	add    $0x10,%esp
801059c7:	85 c0                	test   %eax,%eax
801059c9:	0f 88 a9 00 00 00    	js     80105a78 <sys_wmap+0xf8>
  if(argint(3, &fd) < 0) return FAILED;
801059cf:	83 ec 08             	sub    $0x8,%esp
801059d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059d5:	50                   	push   %eax
801059d6:	6a 03                	push   $0x3
801059d8:	e8 83 f0 ff ff       	call   80104a60 <argint>
801059dd:	83 c4 10             	add    $0x10,%esp
801059e0:	85 c0                	test   %eax,%eax
801059e2:	0f 88 90 00 00 00    	js     80105a78 <sys_wmap+0xf8>

  if(DEBUG) cprintf("Made it before first checks\n");
801059e8:	a1 80 37 11 80       	mov    0x80113780,%eax
801059ed:	85 c0                	test   %eax,%eax
801059ef:	75 4f                	jne    80105a40 <sys_wmap+0xc0>

  // checks
  if(addr < 0x60000000 || addr+length > 0x80000000) return FAILED;
801059f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801059f4:	3d ff ff ff 5f       	cmp    $0x5fffffff,%eax
801059f9:	76 7d                	jbe    80105a78 <sys_wmap+0xf8>
801059fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
801059fe:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80105a01:	81 f9 00 00 00 80    	cmp    $0x80000000,%ecx
80105a07:	77 6f                	ja     80105a78 <sys_wmap+0xf8>
  if((flags & MAP_FIXED) == 0) return FAILED; // MAP_FIXED not set, error
80105a09:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  if((flags & MAP_SHARED) == 0) return FAILED; // MAP_SHARE not set, error
80105a0c:	89 cb                	mov    %ecx,%ebx
80105a0e:	83 e3 0a             	and    $0xa,%ebx
80105a11:	83 fb 0a             	cmp    $0xa,%ebx
80105a14:	75 62                	jne    80105a78 <sys_wmap+0xf8>
  if(addr % PGSIZE != 0){
	return FAILED;
  }

  // if length is not greater than 0
  if (length <= 0) {
80105a16:	a9 ff 0f 00 00       	test   $0xfff,%eax
80105a1b:	75 5b                	jne    80105a78 <sys_wmap+0xf8>
80105a1d:	85 d2                	test   %edx,%edx
80105a1f:	7e 57                	jle    80105a78 <sys_wmap+0xf8>
	return FAILED;
  }

  if(DEBUG) cprintf("Made it after first checks\n");
80105a21:	8b 1d 80 37 11 80    	mov    0x80113780,%ebx
80105a27:	85 db                	test   %ebx,%ebx
80105a29:	75 2d                	jne    80105a58 <sys_wmap+0xd8>
  return wmap(addr, length, flags, fd);
80105a2b:	ff 75 f4             	push   -0xc(%ebp)
80105a2e:	51                   	push   %ecx
80105a2f:	52                   	push   %edx
80105a30:	50                   	push   %eax
80105a31:	e8 ba 28 00 00       	call   801082f0 <wmap>
}
80105a36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return wmap(addr, length, flags, fd);
80105a39:	83 c4 10             	add    $0x10,%esp
}
80105a3c:	c9                   	leave  
80105a3d:	c3                   	ret    
80105a3e:	66 90                	xchg   %ax,%ax
  if(DEBUG) cprintf("Made it before first checks\n");
80105a40:	83 ec 0c             	sub    $0xc,%esp
80105a43:	68 29 8e 10 80       	push   $0x80108e29
80105a48:	e8 53 ac ff ff       	call   801006a0 <cprintf>
80105a4d:	83 c4 10             	add    $0x10,%esp
80105a50:	eb 9f                	jmp    801059f1 <sys_wmap+0x71>
80105a52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(DEBUG) cprintf("Made it after first checks\n");
80105a58:	83 ec 0c             	sub    $0xc,%esp
80105a5b:	68 46 8e 10 80       	push   $0x80108e46
80105a60:	e8 3b ac ff ff       	call   801006a0 <cprintf>
  return wmap(addr, length, flags, fd);
80105a65:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105a68:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105a6b:	83 c4 10             	add    $0x10,%esp
80105a6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105a71:	eb b8                	jmp    80105a2b <sys_wmap+0xab>
80105a73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a77:	90                   	nop
}
80105a78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  if(argint(0, (int *) &addr) < 0) return FAILED;
80105a7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a80:	c9                   	leave  
80105a81:	c3                   	ret    
80105a82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a90 <sys_wunmap>:

int
sys_wunmap(void)
{
80105a90:	55                   	push   %ebp
80105a91:	89 e5                	mov    %esp,%ebp
80105a93:	83 ec 20             	sub    $0x20,%esp
  uint addr;

  if(argint(0, (int *) &addr) < 0) return FAILED;
80105a96:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a99:	50                   	push   %eax
80105a9a:	6a 00                	push   $0x0
80105a9c:	e8 bf ef ff ff       	call   80104a60 <argint>
80105aa1:	83 c4 10             	add    $0x10,%esp
80105aa4:	85 c0                	test   %eax,%eax
80105aa6:	78 48                	js     80105af0 <sys_wunmap+0x60>

  // checks
  if(addr < 0x60000000 || addr > 0x80000000) return FAILED;
80105aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aab:	8d 90 00 00 00 a0    	lea    -0x60000000(%eax),%edx
80105ab1:	81 fa 00 00 00 20    	cmp    $0x20000000,%edx
80105ab7:	77 37                	ja     80105af0 <sys_wunmap+0x60>
  if(DEBUG) cprintf("SYS_WUNMAP: Got pass all the checks!\n");
80105ab9:	8b 15 80 37 11 80    	mov    0x80113780,%edx
80105abf:	85 d2                	test   %edx,%edx
80105ac1:	75 15                	jne    80105ad8 <sys_wunmap+0x48>

  return wunmap(addr);
80105ac3:	83 ec 0c             	sub    $0xc,%esp
80105ac6:	50                   	push   %eax
80105ac7:	e8 24 2a 00 00       	call   801084f0 <wunmap>
80105acc:	83 c4 10             	add    $0x10,%esp
}
80105acf:	c9                   	leave  
80105ad0:	c3                   	ret    
80105ad1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(DEBUG) cprintf("SYS_WUNMAP: Got pass all the checks!\n");
80105ad8:	83 ec 0c             	sub    $0xc,%esp
80105adb:	68 64 8e 10 80       	push   $0x80108e64
80105ae0:	e8 bb ab ff ff       	call   801006a0 <cprintf>
  return wunmap(addr);
80105ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ae8:	83 c4 10             	add    $0x10,%esp
80105aeb:	eb d6                	jmp    80105ac3 <sys_wunmap+0x33>
80105aed:	8d 76 00             	lea    0x0(%esi),%esi
}
80105af0:	c9                   	leave  
  if(argint(0, (int *) &addr) < 0) return FAILED;
80105af1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105af6:	c3                   	ret    
80105af7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105afe:	66 90                	xchg   %ax,%ax

80105b00 <sys_va2pa>:

int
sys_va2pa(void)
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	83 ec 20             	sub    $0x20,%esp
  uint va;

  if(argint(0, (int *) &va) < 0) return -1;
80105b06:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b09:	50                   	push   %eax
80105b0a:	6a 00                	push   $0x0
80105b0c:	e8 4f ef ff ff       	call   80104a60 <argint>
80105b11:	83 c4 10             	add    $0x10,%esp
80105b14:	85 c0                	test   %eax,%eax
80105b16:	78 32                	js     80105b4a <sys_va2pa+0x4a>
  if(DEBUG) cprintf("SYS_VA2PA: Made it after argint and proceed va2pa call.\n");
80105b18:	a1 80 37 11 80       	mov    0x80113780,%eax
80105b1d:	85 c0                	test   %eax,%eax
80105b1f:	75 17                	jne    80105b38 <sys_va2pa+0x38>

  return va2pa(va);
80105b21:	83 ec 0c             	sub    $0xc,%esp
80105b24:	ff 75 f4             	push   -0xc(%ebp)
80105b27:	e8 54 2a 00 00       	call   80108580 <va2pa>
80105b2c:	83 c4 10             	add    $0x10,%esp
}
80105b2f:	c9                   	leave  
80105b30:	c3                   	ret    
80105b31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(DEBUG) cprintf("SYS_VA2PA: Made it after argint and proceed va2pa call.\n");
80105b38:	83 ec 0c             	sub    $0xc,%esp
80105b3b:	68 8c 8e 10 80       	push   $0x80108e8c
80105b40:	e8 5b ab ff ff       	call   801006a0 <cprintf>
80105b45:	83 c4 10             	add    $0x10,%esp
80105b48:	eb d7                	jmp    80105b21 <sys_va2pa+0x21>
}
80105b4a:	c9                   	leave  
  if(argint(0, (int *) &va) < 0) return -1;
80105b4b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b50:	c3                   	ret    
80105b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b5f:	90                   	nop

80105b60 <sys_getwmapinfo>:

int
sys_getwmapinfo(void)
{
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	83 ec 1c             	sub    $0x1c,%esp
  struct wmapinfo *wminfo;

  if(argptr(0, (void *)&wminfo, sizeof(struct wmapinfo)) < 0) return FAILED;
80105b66:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b69:	68 c4 00 00 00       	push   $0xc4
80105b6e:	50                   	push   %eax
80105b6f:	6a 00                	push   $0x0
80105b71:	e8 3a ef ff ff       	call   80104ab0 <argptr>
80105b76:	83 c4 10             	add    $0x10,%esp
80105b79:	85 c0                	test   %eax,%eax
80105b7b:	78 1b                	js     80105b98 <sys_getwmapinfo+0x38>
  if(wminfo == 0) return FAILED;
80105b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b80:	85 c0                	test   %eax,%eax
80105b82:	74 14                	je     80105b98 <sys_getwmapinfo+0x38>

  return getwmapinfo(wminfo);
80105b84:	83 ec 0c             	sub    $0xc,%esp
80105b87:	50                   	push   %eax
80105b88:	e8 73 2a 00 00       	call   80108600 <getwmapinfo>
80105b8d:	83 c4 10             	add    $0x10,%esp
}
80105b90:	c9                   	leave  
80105b91:	c3                   	ret    
80105b92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105b98:	c9                   	leave  
  if(argptr(0, (void *)&wminfo, sizeof(struct wmapinfo)) < 0) return FAILED;
80105b99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b9e:	c3                   	ret    

80105b9f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105b9f:	1e                   	push   %ds
  pushl %es
80105ba0:	06                   	push   %es
  pushl %fs
80105ba1:	0f a0                	push   %fs
  pushl %gs
80105ba3:	0f a8                	push   %gs
  pushal
80105ba5:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105ba6:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105baa:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105bac:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105bae:	54                   	push   %esp
  call trap
80105baf:	e8 cc 00 00 00       	call   80105c80 <trap>
  addl $4, %esp
80105bb4:	83 c4 04             	add    $0x4,%esp

80105bb7 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105bb7:	61                   	popa   
  popl %gs
80105bb8:	0f a9                	pop    %gs
  popl %fs
80105bba:	0f a1                	pop    %fs
  popl %es
80105bbc:	07                   	pop    %es
  popl %ds
80105bbd:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105bbe:	83 c4 08             	add    $0x8,%esp
  iret
80105bc1:	cf                   	iret   
80105bc2:	66 90                	xchg   %ax,%ax
80105bc4:	66 90                	xchg   %ax,%ax
80105bc6:	66 90                	xchg   %ax,%ax
80105bc8:	66 90                	xchg   %ax,%ax
80105bca:	66 90                	xchg   %ax,%ax
80105bcc:	66 90                	xchg   %ax,%ax
80105bce:	66 90                	xchg   %ax,%ax

80105bd0 <tvinit>:
// DEBUG 
extern int DEBUG;

void
tvinit(void)
{
80105bd0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105bd1:	31 c0                	xor    %eax,%eax
{
80105bd3:	89 e5                	mov    %esp,%ebp
80105bd5:	83 ec 08             	sub    $0x8,%esp
80105bd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bdf:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105be0:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
80105be7:	c7 04 c5 e2 ad 21 80 	movl   $0x8e000008,-0x7fde521e(,%eax,8)
80105bee:	08 00 00 8e 
80105bf2:	66 89 14 c5 e0 ad 21 	mov    %dx,-0x7fde5220(,%eax,8)
80105bf9:	80 
80105bfa:	c1 ea 10             	shr    $0x10,%edx
80105bfd:	66 89 14 c5 e6 ad 21 	mov    %dx,-0x7fde521a(,%eax,8)
80105c04:	80 
  for(i = 0; i < 256; i++)
80105c05:	83 c0 01             	add    $0x1,%eax
80105c08:	3d 00 01 00 00       	cmp    $0x100,%eax
80105c0d:	75 d1                	jne    80105be0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105c0f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c12:	a1 08 c1 10 80       	mov    0x8010c108,%eax
80105c17:	c7 05 e2 af 21 80 08 	movl   $0xef000008,0x8021afe2
80105c1e:	00 00 ef 
  initlock(&tickslock, "time");
80105c21:	68 c5 8e 10 80       	push   $0x80108ec5
80105c26:	68 a0 ad 21 80       	push   $0x8021ada0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c2b:	66 a3 e0 af 21 80    	mov    %ax,0x8021afe0
80105c31:	c1 e8 10             	shr    $0x10,%eax
80105c34:	66 a3 e6 af 21 80    	mov    %ax,0x8021afe6
  initlock(&tickslock, "time");
80105c3a:	e8 d1 e8 ff ff       	call   80104510 <initlock>
}
80105c3f:	83 c4 10             	add    $0x10,%esp
80105c42:	c9                   	leave  
80105c43:	c3                   	ret    
80105c44:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c4f:	90                   	nop

80105c50 <idtinit>:

void
idtinit(void)
{
80105c50:	55                   	push   %ebp
  pd[0] = size-1;
80105c51:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105c56:	89 e5                	mov    %esp,%ebp
80105c58:	83 ec 10             	sub    $0x10,%esp
80105c5b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105c5f:	b8 e0 ad 21 80       	mov    $0x8021ade0,%eax
80105c64:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105c68:	c1 e8 10             	shr    $0x10,%eax
80105c6b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105c6f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105c72:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105c75:	c9                   	leave  
80105c76:	c3                   	ret    
80105c77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c7e:	66 90                	xchg   %ax,%ax

80105c80 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105c80:	55                   	push   %ebp
80105c81:	89 e5                	mov    %esp,%ebp
80105c83:	57                   	push   %edi
80105c84:	56                   	push   %esi
80105c85:	53                   	push   %ebx
80105c86:	83 ec 1c             	sub    $0x1c,%esp
80105c89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105c8c:	8b 43 30             	mov    0x30(%ebx),%eax
80105c8f:	83 f8 40             	cmp    $0x40,%eax
80105c92:	0f 84 38 01 00 00    	je     80105dd0 <trap+0x150>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105c98:	83 e8 0e             	sub    $0xe,%eax
80105c9b:	83 f8 31             	cmp    $0x31,%eax
80105c9e:	0f 87 8c 00 00 00    	ja     80105d30 <trap+0xb0>
80105ca4:	ff 24 85 cc 8f 10 80 	jmp    *-0x7fef7034(,%eax,4)
80105cab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105caf:	90                   	nop
	}
	
	break;

  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105cb0:	e8 0b dd ff ff       	call   801039c0 <cpuid>
80105cb5:	85 c0                	test   %eax,%eax
80105cb7:	0f 84 e3 02 00 00    	je     80105fa0 <trap+0x320>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105cbd:	e8 5e cc ff ff       	call   80102920 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cc2:	e8 19 dd ff ff       	call   801039e0 <myproc>
80105cc7:	85 c0                	test   %eax,%eax
80105cc9:	74 1d                	je     80105ce8 <trap+0x68>
80105ccb:	e8 10 dd ff ff       	call   801039e0 <myproc>
80105cd0:	8b 50 24             	mov    0x24(%eax),%edx
80105cd3:	85 d2                	test   %edx,%edx
80105cd5:	74 11                	je     80105ce8 <trap+0x68>
80105cd7:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105cdb:	83 e0 03             	and    $0x3,%eax
80105cde:	66 83 f8 03          	cmp    $0x3,%ax
80105ce2:	0f 84 38 02 00 00    	je     80105f20 <trap+0x2a0>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105ce8:	e8 f3 dc ff ff       	call   801039e0 <myproc>
80105ced:	85 c0                	test   %eax,%eax
80105cef:	74 0f                	je     80105d00 <trap+0x80>
80105cf1:	e8 ea dc ff ff       	call   801039e0 <myproc>
80105cf6:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105cfa:	0f 84 b8 00 00 00    	je     80105db8 <trap+0x138>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d00:	e8 db dc ff ff       	call   801039e0 <myproc>
80105d05:	85 c0                	test   %eax,%eax
80105d07:	74 1d                	je     80105d26 <trap+0xa6>
80105d09:	e8 d2 dc ff ff       	call   801039e0 <myproc>
80105d0e:	8b 40 24             	mov    0x24(%eax),%eax
80105d11:	85 c0                	test   %eax,%eax
80105d13:	74 11                	je     80105d26 <trap+0xa6>
80105d15:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105d19:	83 e0 03             	and    $0x3,%eax
80105d1c:	66 83 f8 03          	cmp    $0x3,%ax
80105d20:	0f 84 d7 00 00 00    	je     80105dfd <trap+0x17d>
    exit();
}
80105d26:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d29:	5b                   	pop    %ebx
80105d2a:	5e                   	pop    %esi
80105d2b:	5f                   	pop    %edi
80105d2c:	5d                   	pop    %ebp
80105d2d:	c3                   	ret    
80105d2e:	66 90                	xchg   %ax,%ax
    if(myproc() == 0 || (tf->cs&3) == 0){
80105d30:	e8 ab dc ff ff       	call   801039e0 <myproc>
80105d35:	85 c0                	test   %eax,%eax
80105d37:	0f 84 db 02 00 00    	je     80106018 <trap+0x398>
80105d3d:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105d41:	0f 84 d1 02 00 00    	je     80106018 <trap+0x398>
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105d47:	0f 20 d1             	mov    %cr2,%ecx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d4a:	8b 53 38             	mov    0x38(%ebx),%edx
80105d4d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105d50:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105d53:	e8 68 dc ff ff       	call   801039c0 <cpuid>
80105d58:	8b 73 30             	mov    0x30(%ebx),%esi
80105d5b:	89 c7                	mov    %eax,%edi
80105d5d:	8b 43 34             	mov    0x34(%ebx),%eax
80105d60:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105d63:	e8 78 dc ff ff       	call   801039e0 <myproc>
80105d68:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105d6b:	e8 70 dc ff ff       	call   801039e0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d70:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105d73:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105d76:	51                   	push   %ecx
80105d77:	52                   	push   %edx
80105d78:	57                   	push   %edi
80105d79:	ff 75 e4             	push   -0x1c(%ebp)
80105d7c:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105d7d:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105d80:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d83:	56                   	push   %esi
80105d84:	ff 70 10             	push   0x10(%eax)
80105d87:	68 88 8f 10 80       	push   $0x80108f88
80105d8c:	e8 0f a9 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80105d91:	83 c4 20             	add    $0x20,%esp
80105d94:	e8 47 dc ff ff       	call   801039e0 <myproc>
80105d99:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105da0:	e8 3b dc ff ff       	call   801039e0 <myproc>
80105da5:	85 c0                	test   %eax,%eax
80105da7:	0f 85 1e ff ff ff    	jne    80105ccb <trap+0x4b>
80105dad:	e9 36 ff ff ff       	jmp    80105ce8 <trap+0x68>
80105db2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105db8:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105dbc:	0f 85 3e ff ff ff    	jne    80105d00 <trap+0x80>
    yield();
80105dc2:	e8 69 e3 ff ff       	call   80104130 <yield>
80105dc7:	e9 34 ff ff ff       	jmp    80105d00 <trap+0x80>
80105dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105dd0:	e8 0b dc ff ff       	call   801039e0 <myproc>
80105dd5:	8b 70 24             	mov    0x24(%eax),%esi
80105dd8:	85 f6                	test   %esi,%esi
80105dda:	0f 85 78 01 00 00    	jne    80105f58 <trap+0x2d8>
    myproc()->tf = tf;
80105de0:	e8 fb db ff ff       	call   801039e0 <myproc>
80105de5:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105de8:	e8 b3 ed ff ff       	call   80104ba0 <syscall>
    if(myproc()->killed)
80105ded:	e8 ee db ff ff       	call   801039e0 <myproc>
80105df2:	8b 58 24             	mov    0x24(%eax),%ebx
80105df5:	85 db                	test   %ebx,%ebx
80105df7:	0f 84 29 ff ff ff    	je     80105d26 <trap+0xa6>
}
80105dfd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e00:	5b                   	pop    %ebx
80105e01:	5e                   	pop    %esi
80105e02:	5f                   	pop    %edi
80105e03:	5d                   	pop    %ebp
      exit();
80105e04:	e9 57 e0 ff ff       	jmp    80103e60 <exit>
80105e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105e10:	8b 7b 38             	mov    0x38(%ebx),%edi
80105e13:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105e17:	e8 a4 db ff ff       	call   801039c0 <cpuid>
80105e1c:	57                   	push   %edi
80105e1d:	56                   	push   %esi
80105e1e:	50                   	push   %eax
80105e1f:	68 30 8f 10 80       	push   $0x80108f30
80105e24:	e8 77 a8 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105e29:	e8 f2 ca ff ff       	call   80102920 <lapiceoi>
    break;
80105e2e:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e31:	e8 aa db ff ff       	call   801039e0 <myproc>
80105e36:	85 c0                	test   %eax,%eax
80105e38:	0f 85 8d fe ff ff    	jne    80105ccb <trap+0x4b>
80105e3e:	e9 a5 fe ff ff       	jmp    80105ce8 <trap+0x68>
80105e43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e47:	90                   	nop
    kbdintr();
80105e48:	e8 93 c9 ff ff       	call   801027e0 <kbdintr>
    lapiceoi();
80105e4d:	e8 ce ca ff ff       	call   80102920 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e52:	e8 89 db ff ff       	call   801039e0 <myproc>
80105e57:	85 c0                	test   %eax,%eax
80105e59:	0f 85 6c fe ff ff    	jne    80105ccb <trap+0x4b>
80105e5f:	e9 84 fe ff ff       	jmp    80105ce8 <trap+0x68>
80105e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105e68:	e8 53 03 00 00       	call   801061c0 <uartintr>
    lapiceoi();
80105e6d:	e8 ae ca ff ff       	call   80102920 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e72:	e8 69 db ff ff       	call   801039e0 <myproc>
80105e77:	85 c0                	test   %eax,%eax
80105e79:	0f 85 4c fe ff ff    	jne    80105ccb <trap+0x4b>
80105e7f:	e9 64 fe ff ff       	jmp    80105ce8 <trap+0x68>
80105e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105e88:	e8 c3 c3 ff ff       	call   80102250 <ideintr>
80105e8d:	e9 2b fe ff ff       	jmp    80105cbd <trap+0x3d>
80105e92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105e98:	0f 20 d7             	mov    %cr2,%edi
80105e9b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
	struct proc *p = myproc();  // Get the current process
80105e9e:	e8 3d db ff ff       	call   801039e0 <myproc>
80105ea3:	89 c6                	mov    %eax,%esi
	if(fault_addr < 0x60000000 || fault_addr >= 0x80000000){
80105ea5:	8d 87 00 00 00 a0    	lea    -0x60000000(%edi),%eax
	for(int i=0; i<MAX_WMMAP_INFO; i++){
80105eab:	31 ff                	xor    %edi,%edi
	if(fault_addr < 0x60000000 || fault_addr >= 0x80000000){
80105ead:	3d ff ff ff 1f       	cmp    $0x1fffffff,%eax
80105eb2:	0f 87 b0 00 00 00    	ja     80105f68 <trap+0x2e8>
80105eb8:	89 5d e0             	mov    %ebx,-0x20(%ebp)
80105ebb:	89 fb                	mov    %edi,%ebx
80105ebd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80105ec0:	eb 3a                	jmp    80105efc <trap+0x27c>
80105ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	  if(((p->wmapInfo).addr)[i] == 0 && ((p->wmapInfo).length)[i] == -1) continue; // skip if the mapping we looking at is invalid
80105ec8:	8b 84 9e 80 00 00 00 	mov    0x80(%esi,%ebx,4),%eax
80105ecf:	8b 8c 9e c0 00 00 00 	mov    0xc0(%esi,%ebx,4),%ecx
80105ed6:	85 c0                	test   %eax,%eax
80105ed8:	75 05                	jne    80105edf <trap+0x25f>
80105eda:	83 f9 ff             	cmp    $0xffffffff,%ecx
80105edd:	74 15                	je     80105ef4 <trap+0x274>
	  if(vasIntersect(fault_addr, 1, ((p->wmapInfo).addr)[i], ((p->wmapInfo).length)[i])){
80105edf:	51                   	push   %ecx
80105ee0:	50                   	push   %eax
80105ee1:	6a 01                	push   $0x1
80105ee3:	57                   	push   %edi
80105ee4:	e8 87 18 00 00       	call   80107770 <vasIntersect>
80105ee9:	83 c4 10             	add    $0x10,%esp
80105eec:	85 c0                	test   %eax,%eax
80105eee:	0f 85 e4 00 00 00    	jne    80105fd8 <trap+0x358>
	for(int i=0; i<MAX_WMMAP_INFO; i++){
80105ef4:	83 c3 01             	add    $0x1,%ebx
80105ef7:	83 fb 10             	cmp    $0x10,%ebx
80105efa:	74 34                	je     80105f30 <trap+0x2b0>
	  if(DEBUG) cprintf("looking if we have that address cover : %d\n", fault_addr);
80105efc:	8b 0d 80 37 11 80    	mov    0x80113780,%ecx
80105f02:	85 c9                	test   %ecx,%ecx
80105f04:	74 c2                	je     80105ec8 <trap+0x248>
80105f06:	83 ec 08             	sub    $0x8,%esp
80105f09:	57                   	push   %edi
80105f0a:	68 e4 8e 10 80       	push   $0x80108ee4
80105f0f:	e8 8c a7 ff ff       	call   801006a0 <cprintf>
80105f14:	83 c4 10             	add    $0x10,%esp
80105f17:	eb af                	jmp    80105ec8 <trap+0x248>
80105f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105f20:	e8 3b df ff ff       	call   80103e60 <exit>
80105f25:	e9 be fd ff ff       	jmp    80105ce8 <trap+0x68>
80105f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	  cprintf("Segmentation Fault\n");
80105f30:	83 ec 0c             	sub    $0xc,%esp
80105f33:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80105f36:	68 ca 8e 10 80       	push   $0x80108eca
80105f3b:	e8 60 a7 ff ff       	call   801006a0 <cprintf>
	  myproc()->killed = 1;
80105f40:	e8 9b da ff ff       	call   801039e0 <myproc>
80105f45:	83 c4 10             	add    $0x10,%esp
80105f48:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105f4f:	e9 6e fd ff ff       	jmp    80105cc2 <trap+0x42>
80105f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      exit();
80105f58:	e8 03 df ff ff       	call   80103e60 <exit>
80105f5d:	e9 7e fe ff ff       	jmp    80105de0 <trap+0x160>
80105f62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	  int han = handle_cow_fault(p, fault_addr);
80105f68:	83 ec 08             	sub    $0x8,%esp
80105f6b:	ff 75 e4             	push   -0x1c(%ebp)
80105f6e:	56                   	push   %esi
80105f6f:	e8 7c 1f 00 00       	call   80107ef0 <handle_cow_fault>
	  if(han != 0){
80105f74:	83 c4 10             	add    $0x10,%esp
80105f77:	85 c0                	test   %eax,%eax
80105f79:	0f 84 43 fd ff ff    	je     80105cc2 <trap+0x42>
		cprintf("Segmentation Fault\n");
80105f7f:	83 ec 0c             	sub    $0xc,%esp
80105f82:	68 ca 8e 10 80       	push   $0x80108eca
80105f87:	e8 14 a7 ff ff       	call   801006a0 <cprintf>
		p->killed = 1;
80105f8c:	c7 46 24 01 00 00 00 	movl   $0x1,0x24(%esi)
80105f93:	83 c4 10             	add    $0x10,%esp
80105f96:	e9 27 fd ff ff       	jmp    80105cc2 <trap+0x42>
80105f9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f9f:	90                   	nop
      acquire(&tickslock);
80105fa0:	83 ec 0c             	sub    $0xc,%esp
80105fa3:	68 a0 ad 21 80       	push   $0x8021ada0
80105fa8:	e8 33 e7 ff ff       	call   801046e0 <acquire>
      wakeup(&ticks);
80105fad:	c7 04 24 80 ad 21 80 	movl   $0x8021ad80,(%esp)
      ticks++;
80105fb4:	83 05 80 ad 21 80 01 	addl   $0x1,0x8021ad80
      wakeup(&ticks);
80105fbb:	e8 80 e2 ff ff       	call   80104240 <wakeup>
      release(&tickslock);
80105fc0:	c7 04 24 a0 ad 21 80 	movl   $0x8021ada0,(%esp)
80105fc7:	e8 b4 e6 ff ff       	call   80104680 <release>
80105fcc:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105fcf:	e9 e9 fc ff ff       	jmp    80105cbd <trap+0x3d>
80105fd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	  if(allocateAndMap(p, fault_addr, PGSIZE, index) != 0){
80105fd8:	89 df                	mov    %ebx,%edi
80105fda:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80105fdd:	57                   	push   %edi
80105fde:	68 00 10 00 00       	push   $0x1000
80105fe3:	ff 75 e4             	push   -0x1c(%ebp)
80105fe6:	56                   	push   %esi
80105fe7:	e8 74 1a 00 00       	call   80107a60 <allocateAndMap>
80105fec:	83 c4 10             	add    $0x10,%esp
80105fef:	85 c0                	test   %eax,%eax
80105ff1:	0f 84 cb fc ff ff    	je     80105cc2 <trap+0x42>
		cprintf("Allocating and mapping failed\n");
80105ff7:	83 ec 0c             	sub    $0xc,%esp
80105ffa:	68 10 8f 10 80       	push   $0x80108f10
80105fff:	e8 9c a6 ff ff       	call   801006a0 <cprintf>
		myproc()->killed = 1;
80106004:	e8 d7 d9 ff ff       	call   801039e0 <myproc>
80106009:	83 c4 10             	add    $0x10,%esp
8010600c:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106013:	e9 aa fc ff ff       	jmp    80105cc2 <trap+0x42>
80106018:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010601b:	8b 73 38             	mov    0x38(%ebx),%esi
8010601e:	e8 9d d9 ff ff       	call   801039c0 <cpuid>
80106023:	83 ec 0c             	sub    $0xc,%esp
80106026:	57                   	push   %edi
80106027:	56                   	push   %esi
80106028:	50                   	push   %eax
80106029:	ff 73 30             	push   0x30(%ebx)
8010602c:	68 54 8f 10 80       	push   $0x80108f54
80106031:	e8 6a a6 ff ff       	call   801006a0 <cprintf>
      panic("trap");
80106036:	83 c4 14             	add    $0x14,%esp
80106039:	68 de 8e 10 80       	push   $0x80108ede
8010603e:	e8 3d a3 ff ff       	call   80100380 <panic>
80106043:	66 90                	xchg   %ax,%ax
80106045:	66 90                	xchg   %ax,%ax
80106047:	66 90                	xchg   %ax,%ax
80106049:	66 90                	xchg   %ax,%ax
8010604b:	66 90                	xchg   %ax,%ax
8010604d:	66 90                	xchg   %ax,%ax
8010604f:	90                   	nop

80106050 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106050:	a1 e0 b5 21 80       	mov    0x8021b5e0,%eax
80106055:	85 c0                	test   %eax,%eax
80106057:	74 17                	je     80106070 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106059:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010605e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010605f:	a8 01                	test   $0x1,%al
80106061:	74 0d                	je     80106070 <uartgetc+0x20>
80106063:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106068:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106069:	0f b6 c0             	movzbl %al,%eax
8010606c:	c3                   	ret    
8010606d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106070:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106075:	c3                   	ret    
80106076:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010607d:	8d 76 00             	lea    0x0(%esi),%esi

80106080 <uartinit>:
{
80106080:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106081:	31 c9                	xor    %ecx,%ecx
80106083:	89 c8                	mov    %ecx,%eax
80106085:	89 e5                	mov    %esp,%ebp
80106087:	57                   	push   %edi
80106088:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010608d:	56                   	push   %esi
8010608e:	89 fa                	mov    %edi,%edx
80106090:	53                   	push   %ebx
80106091:	83 ec 1c             	sub    $0x1c,%esp
80106094:	ee                   	out    %al,(%dx)
80106095:	be fb 03 00 00       	mov    $0x3fb,%esi
8010609a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010609f:	89 f2                	mov    %esi,%edx
801060a1:	ee                   	out    %al,(%dx)
801060a2:	b8 0c 00 00 00       	mov    $0xc,%eax
801060a7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060ac:	ee                   	out    %al,(%dx)
801060ad:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801060b2:	89 c8                	mov    %ecx,%eax
801060b4:	89 da                	mov    %ebx,%edx
801060b6:	ee                   	out    %al,(%dx)
801060b7:	b8 03 00 00 00       	mov    $0x3,%eax
801060bc:	89 f2                	mov    %esi,%edx
801060be:	ee                   	out    %al,(%dx)
801060bf:	ba fc 03 00 00       	mov    $0x3fc,%edx
801060c4:	89 c8                	mov    %ecx,%eax
801060c6:	ee                   	out    %al,(%dx)
801060c7:	b8 01 00 00 00       	mov    $0x1,%eax
801060cc:	89 da                	mov    %ebx,%edx
801060ce:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801060cf:	ba fd 03 00 00       	mov    $0x3fd,%edx
801060d4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801060d5:	3c ff                	cmp    $0xff,%al
801060d7:	74 78                	je     80106151 <uartinit+0xd1>
  uart = 1;
801060d9:	c7 05 e0 b5 21 80 01 	movl   $0x1,0x8021b5e0
801060e0:	00 00 00 
801060e3:	89 fa                	mov    %edi,%edx
801060e5:	ec                   	in     (%dx),%al
801060e6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060eb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801060ec:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801060ef:	bf 94 90 10 80       	mov    $0x80109094,%edi
801060f4:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
801060f9:	6a 00                	push   $0x0
801060fb:	6a 04                	push   $0x4
801060fd:	e8 8e c3 ff ff       	call   80102490 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106102:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106106:	83 c4 10             	add    $0x10,%esp
80106109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106110:	a1 e0 b5 21 80       	mov    0x8021b5e0,%eax
80106115:	bb 80 00 00 00       	mov    $0x80,%ebx
8010611a:	85 c0                	test   %eax,%eax
8010611c:	75 14                	jne    80106132 <uartinit+0xb2>
8010611e:	eb 23                	jmp    80106143 <uartinit+0xc3>
    microdelay(10);
80106120:	83 ec 0c             	sub    $0xc,%esp
80106123:	6a 0a                	push   $0xa
80106125:	e8 16 c8 ff ff       	call   80102940 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010612a:	83 c4 10             	add    $0x10,%esp
8010612d:	83 eb 01             	sub    $0x1,%ebx
80106130:	74 07                	je     80106139 <uartinit+0xb9>
80106132:	89 f2                	mov    %esi,%edx
80106134:	ec                   	in     (%dx),%al
80106135:	a8 20                	test   $0x20,%al
80106137:	74 e7                	je     80106120 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106139:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010613d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106142:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106143:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106147:	83 c7 01             	add    $0x1,%edi
8010614a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010614d:	84 c0                	test   %al,%al
8010614f:	75 bf                	jne    80106110 <uartinit+0x90>
}
80106151:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106154:	5b                   	pop    %ebx
80106155:	5e                   	pop    %esi
80106156:	5f                   	pop    %edi
80106157:	5d                   	pop    %ebp
80106158:	c3                   	ret    
80106159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106160 <uartputc>:
  if(!uart)
80106160:	a1 e0 b5 21 80       	mov    0x8021b5e0,%eax
80106165:	85 c0                	test   %eax,%eax
80106167:	74 47                	je     801061b0 <uartputc+0x50>
{
80106169:	55                   	push   %ebp
8010616a:	89 e5                	mov    %esp,%ebp
8010616c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010616d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106172:	53                   	push   %ebx
80106173:	bb 80 00 00 00       	mov    $0x80,%ebx
80106178:	eb 18                	jmp    80106192 <uartputc+0x32>
8010617a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106180:	83 ec 0c             	sub    $0xc,%esp
80106183:	6a 0a                	push   $0xa
80106185:	e8 b6 c7 ff ff       	call   80102940 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010618a:	83 c4 10             	add    $0x10,%esp
8010618d:	83 eb 01             	sub    $0x1,%ebx
80106190:	74 07                	je     80106199 <uartputc+0x39>
80106192:	89 f2                	mov    %esi,%edx
80106194:	ec                   	in     (%dx),%al
80106195:	a8 20                	test   $0x20,%al
80106197:	74 e7                	je     80106180 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106199:	8b 45 08             	mov    0x8(%ebp),%eax
8010619c:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061a1:	ee                   	out    %al,(%dx)
}
801061a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801061a5:	5b                   	pop    %ebx
801061a6:	5e                   	pop    %esi
801061a7:	5d                   	pop    %ebp
801061a8:	c3                   	ret    
801061a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061b0:	c3                   	ret    
801061b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061bf:	90                   	nop

801061c0 <uartintr>:

void
uartintr(void)
{
801061c0:	55                   	push   %ebp
801061c1:	89 e5                	mov    %esp,%ebp
801061c3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801061c6:	68 50 60 10 80       	push   $0x80106050
801061cb:	e8 b0 a6 ff ff       	call   80100880 <consoleintr>
}
801061d0:	83 c4 10             	add    $0x10,%esp
801061d3:	c9                   	leave  
801061d4:	c3                   	ret    

801061d5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801061d5:	6a 00                	push   $0x0
  pushl $0
801061d7:	6a 00                	push   $0x0
  jmp alltraps
801061d9:	e9 c1 f9 ff ff       	jmp    80105b9f <alltraps>

801061de <vector1>:
.globl vector1
vector1:
  pushl $0
801061de:	6a 00                	push   $0x0
  pushl $1
801061e0:	6a 01                	push   $0x1
  jmp alltraps
801061e2:	e9 b8 f9 ff ff       	jmp    80105b9f <alltraps>

801061e7 <vector2>:
.globl vector2
vector2:
  pushl $0
801061e7:	6a 00                	push   $0x0
  pushl $2
801061e9:	6a 02                	push   $0x2
  jmp alltraps
801061eb:	e9 af f9 ff ff       	jmp    80105b9f <alltraps>

801061f0 <vector3>:
.globl vector3
vector3:
  pushl $0
801061f0:	6a 00                	push   $0x0
  pushl $3
801061f2:	6a 03                	push   $0x3
  jmp alltraps
801061f4:	e9 a6 f9 ff ff       	jmp    80105b9f <alltraps>

801061f9 <vector4>:
.globl vector4
vector4:
  pushl $0
801061f9:	6a 00                	push   $0x0
  pushl $4
801061fb:	6a 04                	push   $0x4
  jmp alltraps
801061fd:	e9 9d f9 ff ff       	jmp    80105b9f <alltraps>

80106202 <vector5>:
.globl vector5
vector5:
  pushl $0
80106202:	6a 00                	push   $0x0
  pushl $5
80106204:	6a 05                	push   $0x5
  jmp alltraps
80106206:	e9 94 f9 ff ff       	jmp    80105b9f <alltraps>

8010620b <vector6>:
.globl vector6
vector6:
  pushl $0
8010620b:	6a 00                	push   $0x0
  pushl $6
8010620d:	6a 06                	push   $0x6
  jmp alltraps
8010620f:	e9 8b f9 ff ff       	jmp    80105b9f <alltraps>

80106214 <vector7>:
.globl vector7
vector7:
  pushl $0
80106214:	6a 00                	push   $0x0
  pushl $7
80106216:	6a 07                	push   $0x7
  jmp alltraps
80106218:	e9 82 f9 ff ff       	jmp    80105b9f <alltraps>

8010621d <vector8>:
.globl vector8
vector8:
  pushl $8
8010621d:	6a 08                	push   $0x8
  jmp alltraps
8010621f:	e9 7b f9 ff ff       	jmp    80105b9f <alltraps>

80106224 <vector9>:
.globl vector9
vector9:
  pushl $0
80106224:	6a 00                	push   $0x0
  pushl $9
80106226:	6a 09                	push   $0x9
  jmp alltraps
80106228:	e9 72 f9 ff ff       	jmp    80105b9f <alltraps>

8010622d <vector10>:
.globl vector10
vector10:
  pushl $10
8010622d:	6a 0a                	push   $0xa
  jmp alltraps
8010622f:	e9 6b f9 ff ff       	jmp    80105b9f <alltraps>

80106234 <vector11>:
.globl vector11
vector11:
  pushl $11
80106234:	6a 0b                	push   $0xb
  jmp alltraps
80106236:	e9 64 f9 ff ff       	jmp    80105b9f <alltraps>

8010623b <vector12>:
.globl vector12
vector12:
  pushl $12
8010623b:	6a 0c                	push   $0xc
  jmp alltraps
8010623d:	e9 5d f9 ff ff       	jmp    80105b9f <alltraps>

80106242 <vector13>:
.globl vector13
vector13:
  pushl $13
80106242:	6a 0d                	push   $0xd
  jmp alltraps
80106244:	e9 56 f9 ff ff       	jmp    80105b9f <alltraps>

80106249 <vector14>:
.globl vector14
vector14:
  pushl $14
80106249:	6a 0e                	push   $0xe
  jmp alltraps
8010624b:	e9 4f f9 ff ff       	jmp    80105b9f <alltraps>

80106250 <vector15>:
.globl vector15
vector15:
  pushl $0
80106250:	6a 00                	push   $0x0
  pushl $15
80106252:	6a 0f                	push   $0xf
  jmp alltraps
80106254:	e9 46 f9 ff ff       	jmp    80105b9f <alltraps>

80106259 <vector16>:
.globl vector16
vector16:
  pushl $0
80106259:	6a 00                	push   $0x0
  pushl $16
8010625b:	6a 10                	push   $0x10
  jmp alltraps
8010625d:	e9 3d f9 ff ff       	jmp    80105b9f <alltraps>

80106262 <vector17>:
.globl vector17
vector17:
  pushl $17
80106262:	6a 11                	push   $0x11
  jmp alltraps
80106264:	e9 36 f9 ff ff       	jmp    80105b9f <alltraps>

80106269 <vector18>:
.globl vector18
vector18:
  pushl $0
80106269:	6a 00                	push   $0x0
  pushl $18
8010626b:	6a 12                	push   $0x12
  jmp alltraps
8010626d:	e9 2d f9 ff ff       	jmp    80105b9f <alltraps>

80106272 <vector19>:
.globl vector19
vector19:
  pushl $0
80106272:	6a 00                	push   $0x0
  pushl $19
80106274:	6a 13                	push   $0x13
  jmp alltraps
80106276:	e9 24 f9 ff ff       	jmp    80105b9f <alltraps>

8010627b <vector20>:
.globl vector20
vector20:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $20
8010627d:	6a 14                	push   $0x14
  jmp alltraps
8010627f:	e9 1b f9 ff ff       	jmp    80105b9f <alltraps>

80106284 <vector21>:
.globl vector21
vector21:
  pushl $0
80106284:	6a 00                	push   $0x0
  pushl $21
80106286:	6a 15                	push   $0x15
  jmp alltraps
80106288:	e9 12 f9 ff ff       	jmp    80105b9f <alltraps>

8010628d <vector22>:
.globl vector22
vector22:
  pushl $0
8010628d:	6a 00                	push   $0x0
  pushl $22
8010628f:	6a 16                	push   $0x16
  jmp alltraps
80106291:	e9 09 f9 ff ff       	jmp    80105b9f <alltraps>

80106296 <vector23>:
.globl vector23
vector23:
  pushl $0
80106296:	6a 00                	push   $0x0
  pushl $23
80106298:	6a 17                	push   $0x17
  jmp alltraps
8010629a:	e9 00 f9 ff ff       	jmp    80105b9f <alltraps>

8010629f <vector24>:
.globl vector24
vector24:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $24
801062a1:	6a 18                	push   $0x18
  jmp alltraps
801062a3:	e9 f7 f8 ff ff       	jmp    80105b9f <alltraps>

801062a8 <vector25>:
.globl vector25
vector25:
  pushl $0
801062a8:	6a 00                	push   $0x0
  pushl $25
801062aa:	6a 19                	push   $0x19
  jmp alltraps
801062ac:	e9 ee f8 ff ff       	jmp    80105b9f <alltraps>

801062b1 <vector26>:
.globl vector26
vector26:
  pushl $0
801062b1:	6a 00                	push   $0x0
  pushl $26
801062b3:	6a 1a                	push   $0x1a
  jmp alltraps
801062b5:	e9 e5 f8 ff ff       	jmp    80105b9f <alltraps>

801062ba <vector27>:
.globl vector27
vector27:
  pushl $0
801062ba:	6a 00                	push   $0x0
  pushl $27
801062bc:	6a 1b                	push   $0x1b
  jmp alltraps
801062be:	e9 dc f8 ff ff       	jmp    80105b9f <alltraps>

801062c3 <vector28>:
.globl vector28
vector28:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $28
801062c5:	6a 1c                	push   $0x1c
  jmp alltraps
801062c7:	e9 d3 f8 ff ff       	jmp    80105b9f <alltraps>

801062cc <vector29>:
.globl vector29
vector29:
  pushl $0
801062cc:	6a 00                	push   $0x0
  pushl $29
801062ce:	6a 1d                	push   $0x1d
  jmp alltraps
801062d0:	e9 ca f8 ff ff       	jmp    80105b9f <alltraps>

801062d5 <vector30>:
.globl vector30
vector30:
  pushl $0
801062d5:	6a 00                	push   $0x0
  pushl $30
801062d7:	6a 1e                	push   $0x1e
  jmp alltraps
801062d9:	e9 c1 f8 ff ff       	jmp    80105b9f <alltraps>

801062de <vector31>:
.globl vector31
vector31:
  pushl $0
801062de:	6a 00                	push   $0x0
  pushl $31
801062e0:	6a 1f                	push   $0x1f
  jmp alltraps
801062e2:	e9 b8 f8 ff ff       	jmp    80105b9f <alltraps>

801062e7 <vector32>:
.globl vector32
vector32:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $32
801062e9:	6a 20                	push   $0x20
  jmp alltraps
801062eb:	e9 af f8 ff ff       	jmp    80105b9f <alltraps>

801062f0 <vector33>:
.globl vector33
vector33:
  pushl $0
801062f0:	6a 00                	push   $0x0
  pushl $33
801062f2:	6a 21                	push   $0x21
  jmp alltraps
801062f4:	e9 a6 f8 ff ff       	jmp    80105b9f <alltraps>

801062f9 <vector34>:
.globl vector34
vector34:
  pushl $0
801062f9:	6a 00                	push   $0x0
  pushl $34
801062fb:	6a 22                	push   $0x22
  jmp alltraps
801062fd:	e9 9d f8 ff ff       	jmp    80105b9f <alltraps>

80106302 <vector35>:
.globl vector35
vector35:
  pushl $0
80106302:	6a 00                	push   $0x0
  pushl $35
80106304:	6a 23                	push   $0x23
  jmp alltraps
80106306:	e9 94 f8 ff ff       	jmp    80105b9f <alltraps>

8010630b <vector36>:
.globl vector36
vector36:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $36
8010630d:	6a 24                	push   $0x24
  jmp alltraps
8010630f:	e9 8b f8 ff ff       	jmp    80105b9f <alltraps>

80106314 <vector37>:
.globl vector37
vector37:
  pushl $0
80106314:	6a 00                	push   $0x0
  pushl $37
80106316:	6a 25                	push   $0x25
  jmp alltraps
80106318:	e9 82 f8 ff ff       	jmp    80105b9f <alltraps>

8010631d <vector38>:
.globl vector38
vector38:
  pushl $0
8010631d:	6a 00                	push   $0x0
  pushl $38
8010631f:	6a 26                	push   $0x26
  jmp alltraps
80106321:	e9 79 f8 ff ff       	jmp    80105b9f <alltraps>

80106326 <vector39>:
.globl vector39
vector39:
  pushl $0
80106326:	6a 00                	push   $0x0
  pushl $39
80106328:	6a 27                	push   $0x27
  jmp alltraps
8010632a:	e9 70 f8 ff ff       	jmp    80105b9f <alltraps>

8010632f <vector40>:
.globl vector40
vector40:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $40
80106331:	6a 28                	push   $0x28
  jmp alltraps
80106333:	e9 67 f8 ff ff       	jmp    80105b9f <alltraps>

80106338 <vector41>:
.globl vector41
vector41:
  pushl $0
80106338:	6a 00                	push   $0x0
  pushl $41
8010633a:	6a 29                	push   $0x29
  jmp alltraps
8010633c:	e9 5e f8 ff ff       	jmp    80105b9f <alltraps>

80106341 <vector42>:
.globl vector42
vector42:
  pushl $0
80106341:	6a 00                	push   $0x0
  pushl $42
80106343:	6a 2a                	push   $0x2a
  jmp alltraps
80106345:	e9 55 f8 ff ff       	jmp    80105b9f <alltraps>

8010634a <vector43>:
.globl vector43
vector43:
  pushl $0
8010634a:	6a 00                	push   $0x0
  pushl $43
8010634c:	6a 2b                	push   $0x2b
  jmp alltraps
8010634e:	e9 4c f8 ff ff       	jmp    80105b9f <alltraps>

80106353 <vector44>:
.globl vector44
vector44:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $44
80106355:	6a 2c                	push   $0x2c
  jmp alltraps
80106357:	e9 43 f8 ff ff       	jmp    80105b9f <alltraps>

8010635c <vector45>:
.globl vector45
vector45:
  pushl $0
8010635c:	6a 00                	push   $0x0
  pushl $45
8010635e:	6a 2d                	push   $0x2d
  jmp alltraps
80106360:	e9 3a f8 ff ff       	jmp    80105b9f <alltraps>

80106365 <vector46>:
.globl vector46
vector46:
  pushl $0
80106365:	6a 00                	push   $0x0
  pushl $46
80106367:	6a 2e                	push   $0x2e
  jmp alltraps
80106369:	e9 31 f8 ff ff       	jmp    80105b9f <alltraps>

8010636e <vector47>:
.globl vector47
vector47:
  pushl $0
8010636e:	6a 00                	push   $0x0
  pushl $47
80106370:	6a 2f                	push   $0x2f
  jmp alltraps
80106372:	e9 28 f8 ff ff       	jmp    80105b9f <alltraps>

80106377 <vector48>:
.globl vector48
vector48:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $48
80106379:	6a 30                	push   $0x30
  jmp alltraps
8010637b:	e9 1f f8 ff ff       	jmp    80105b9f <alltraps>

80106380 <vector49>:
.globl vector49
vector49:
  pushl $0
80106380:	6a 00                	push   $0x0
  pushl $49
80106382:	6a 31                	push   $0x31
  jmp alltraps
80106384:	e9 16 f8 ff ff       	jmp    80105b9f <alltraps>

80106389 <vector50>:
.globl vector50
vector50:
  pushl $0
80106389:	6a 00                	push   $0x0
  pushl $50
8010638b:	6a 32                	push   $0x32
  jmp alltraps
8010638d:	e9 0d f8 ff ff       	jmp    80105b9f <alltraps>

80106392 <vector51>:
.globl vector51
vector51:
  pushl $0
80106392:	6a 00                	push   $0x0
  pushl $51
80106394:	6a 33                	push   $0x33
  jmp alltraps
80106396:	e9 04 f8 ff ff       	jmp    80105b9f <alltraps>

8010639b <vector52>:
.globl vector52
vector52:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $52
8010639d:	6a 34                	push   $0x34
  jmp alltraps
8010639f:	e9 fb f7 ff ff       	jmp    80105b9f <alltraps>

801063a4 <vector53>:
.globl vector53
vector53:
  pushl $0
801063a4:	6a 00                	push   $0x0
  pushl $53
801063a6:	6a 35                	push   $0x35
  jmp alltraps
801063a8:	e9 f2 f7 ff ff       	jmp    80105b9f <alltraps>

801063ad <vector54>:
.globl vector54
vector54:
  pushl $0
801063ad:	6a 00                	push   $0x0
  pushl $54
801063af:	6a 36                	push   $0x36
  jmp alltraps
801063b1:	e9 e9 f7 ff ff       	jmp    80105b9f <alltraps>

801063b6 <vector55>:
.globl vector55
vector55:
  pushl $0
801063b6:	6a 00                	push   $0x0
  pushl $55
801063b8:	6a 37                	push   $0x37
  jmp alltraps
801063ba:	e9 e0 f7 ff ff       	jmp    80105b9f <alltraps>

801063bf <vector56>:
.globl vector56
vector56:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $56
801063c1:	6a 38                	push   $0x38
  jmp alltraps
801063c3:	e9 d7 f7 ff ff       	jmp    80105b9f <alltraps>

801063c8 <vector57>:
.globl vector57
vector57:
  pushl $0
801063c8:	6a 00                	push   $0x0
  pushl $57
801063ca:	6a 39                	push   $0x39
  jmp alltraps
801063cc:	e9 ce f7 ff ff       	jmp    80105b9f <alltraps>

801063d1 <vector58>:
.globl vector58
vector58:
  pushl $0
801063d1:	6a 00                	push   $0x0
  pushl $58
801063d3:	6a 3a                	push   $0x3a
  jmp alltraps
801063d5:	e9 c5 f7 ff ff       	jmp    80105b9f <alltraps>

801063da <vector59>:
.globl vector59
vector59:
  pushl $0
801063da:	6a 00                	push   $0x0
  pushl $59
801063dc:	6a 3b                	push   $0x3b
  jmp alltraps
801063de:	e9 bc f7 ff ff       	jmp    80105b9f <alltraps>

801063e3 <vector60>:
.globl vector60
vector60:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $60
801063e5:	6a 3c                	push   $0x3c
  jmp alltraps
801063e7:	e9 b3 f7 ff ff       	jmp    80105b9f <alltraps>

801063ec <vector61>:
.globl vector61
vector61:
  pushl $0
801063ec:	6a 00                	push   $0x0
  pushl $61
801063ee:	6a 3d                	push   $0x3d
  jmp alltraps
801063f0:	e9 aa f7 ff ff       	jmp    80105b9f <alltraps>

801063f5 <vector62>:
.globl vector62
vector62:
  pushl $0
801063f5:	6a 00                	push   $0x0
  pushl $62
801063f7:	6a 3e                	push   $0x3e
  jmp alltraps
801063f9:	e9 a1 f7 ff ff       	jmp    80105b9f <alltraps>

801063fe <vector63>:
.globl vector63
vector63:
  pushl $0
801063fe:	6a 00                	push   $0x0
  pushl $63
80106400:	6a 3f                	push   $0x3f
  jmp alltraps
80106402:	e9 98 f7 ff ff       	jmp    80105b9f <alltraps>

80106407 <vector64>:
.globl vector64
vector64:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $64
80106409:	6a 40                	push   $0x40
  jmp alltraps
8010640b:	e9 8f f7 ff ff       	jmp    80105b9f <alltraps>

80106410 <vector65>:
.globl vector65
vector65:
  pushl $0
80106410:	6a 00                	push   $0x0
  pushl $65
80106412:	6a 41                	push   $0x41
  jmp alltraps
80106414:	e9 86 f7 ff ff       	jmp    80105b9f <alltraps>

80106419 <vector66>:
.globl vector66
vector66:
  pushl $0
80106419:	6a 00                	push   $0x0
  pushl $66
8010641b:	6a 42                	push   $0x42
  jmp alltraps
8010641d:	e9 7d f7 ff ff       	jmp    80105b9f <alltraps>

80106422 <vector67>:
.globl vector67
vector67:
  pushl $0
80106422:	6a 00                	push   $0x0
  pushl $67
80106424:	6a 43                	push   $0x43
  jmp alltraps
80106426:	e9 74 f7 ff ff       	jmp    80105b9f <alltraps>

8010642b <vector68>:
.globl vector68
vector68:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $68
8010642d:	6a 44                	push   $0x44
  jmp alltraps
8010642f:	e9 6b f7 ff ff       	jmp    80105b9f <alltraps>

80106434 <vector69>:
.globl vector69
vector69:
  pushl $0
80106434:	6a 00                	push   $0x0
  pushl $69
80106436:	6a 45                	push   $0x45
  jmp alltraps
80106438:	e9 62 f7 ff ff       	jmp    80105b9f <alltraps>

8010643d <vector70>:
.globl vector70
vector70:
  pushl $0
8010643d:	6a 00                	push   $0x0
  pushl $70
8010643f:	6a 46                	push   $0x46
  jmp alltraps
80106441:	e9 59 f7 ff ff       	jmp    80105b9f <alltraps>

80106446 <vector71>:
.globl vector71
vector71:
  pushl $0
80106446:	6a 00                	push   $0x0
  pushl $71
80106448:	6a 47                	push   $0x47
  jmp alltraps
8010644a:	e9 50 f7 ff ff       	jmp    80105b9f <alltraps>

8010644f <vector72>:
.globl vector72
vector72:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $72
80106451:	6a 48                	push   $0x48
  jmp alltraps
80106453:	e9 47 f7 ff ff       	jmp    80105b9f <alltraps>

80106458 <vector73>:
.globl vector73
vector73:
  pushl $0
80106458:	6a 00                	push   $0x0
  pushl $73
8010645a:	6a 49                	push   $0x49
  jmp alltraps
8010645c:	e9 3e f7 ff ff       	jmp    80105b9f <alltraps>

80106461 <vector74>:
.globl vector74
vector74:
  pushl $0
80106461:	6a 00                	push   $0x0
  pushl $74
80106463:	6a 4a                	push   $0x4a
  jmp alltraps
80106465:	e9 35 f7 ff ff       	jmp    80105b9f <alltraps>

8010646a <vector75>:
.globl vector75
vector75:
  pushl $0
8010646a:	6a 00                	push   $0x0
  pushl $75
8010646c:	6a 4b                	push   $0x4b
  jmp alltraps
8010646e:	e9 2c f7 ff ff       	jmp    80105b9f <alltraps>

80106473 <vector76>:
.globl vector76
vector76:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $76
80106475:	6a 4c                	push   $0x4c
  jmp alltraps
80106477:	e9 23 f7 ff ff       	jmp    80105b9f <alltraps>

8010647c <vector77>:
.globl vector77
vector77:
  pushl $0
8010647c:	6a 00                	push   $0x0
  pushl $77
8010647e:	6a 4d                	push   $0x4d
  jmp alltraps
80106480:	e9 1a f7 ff ff       	jmp    80105b9f <alltraps>

80106485 <vector78>:
.globl vector78
vector78:
  pushl $0
80106485:	6a 00                	push   $0x0
  pushl $78
80106487:	6a 4e                	push   $0x4e
  jmp alltraps
80106489:	e9 11 f7 ff ff       	jmp    80105b9f <alltraps>

8010648e <vector79>:
.globl vector79
vector79:
  pushl $0
8010648e:	6a 00                	push   $0x0
  pushl $79
80106490:	6a 4f                	push   $0x4f
  jmp alltraps
80106492:	e9 08 f7 ff ff       	jmp    80105b9f <alltraps>

80106497 <vector80>:
.globl vector80
vector80:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $80
80106499:	6a 50                	push   $0x50
  jmp alltraps
8010649b:	e9 ff f6 ff ff       	jmp    80105b9f <alltraps>

801064a0 <vector81>:
.globl vector81
vector81:
  pushl $0
801064a0:	6a 00                	push   $0x0
  pushl $81
801064a2:	6a 51                	push   $0x51
  jmp alltraps
801064a4:	e9 f6 f6 ff ff       	jmp    80105b9f <alltraps>

801064a9 <vector82>:
.globl vector82
vector82:
  pushl $0
801064a9:	6a 00                	push   $0x0
  pushl $82
801064ab:	6a 52                	push   $0x52
  jmp alltraps
801064ad:	e9 ed f6 ff ff       	jmp    80105b9f <alltraps>

801064b2 <vector83>:
.globl vector83
vector83:
  pushl $0
801064b2:	6a 00                	push   $0x0
  pushl $83
801064b4:	6a 53                	push   $0x53
  jmp alltraps
801064b6:	e9 e4 f6 ff ff       	jmp    80105b9f <alltraps>

801064bb <vector84>:
.globl vector84
vector84:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $84
801064bd:	6a 54                	push   $0x54
  jmp alltraps
801064bf:	e9 db f6 ff ff       	jmp    80105b9f <alltraps>

801064c4 <vector85>:
.globl vector85
vector85:
  pushl $0
801064c4:	6a 00                	push   $0x0
  pushl $85
801064c6:	6a 55                	push   $0x55
  jmp alltraps
801064c8:	e9 d2 f6 ff ff       	jmp    80105b9f <alltraps>

801064cd <vector86>:
.globl vector86
vector86:
  pushl $0
801064cd:	6a 00                	push   $0x0
  pushl $86
801064cf:	6a 56                	push   $0x56
  jmp alltraps
801064d1:	e9 c9 f6 ff ff       	jmp    80105b9f <alltraps>

801064d6 <vector87>:
.globl vector87
vector87:
  pushl $0
801064d6:	6a 00                	push   $0x0
  pushl $87
801064d8:	6a 57                	push   $0x57
  jmp alltraps
801064da:	e9 c0 f6 ff ff       	jmp    80105b9f <alltraps>

801064df <vector88>:
.globl vector88
vector88:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $88
801064e1:	6a 58                	push   $0x58
  jmp alltraps
801064e3:	e9 b7 f6 ff ff       	jmp    80105b9f <alltraps>

801064e8 <vector89>:
.globl vector89
vector89:
  pushl $0
801064e8:	6a 00                	push   $0x0
  pushl $89
801064ea:	6a 59                	push   $0x59
  jmp alltraps
801064ec:	e9 ae f6 ff ff       	jmp    80105b9f <alltraps>

801064f1 <vector90>:
.globl vector90
vector90:
  pushl $0
801064f1:	6a 00                	push   $0x0
  pushl $90
801064f3:	6a 5a                	push   $0x5a
  jmp alltraps
801064f5:	e9 a5 f6 ff ff       	jmp    80105b9f <alltraps>

801064fa <vector91>:
.globl vector91
vector91:
  pushl $0
801064fa:	6a 00                	push   $0x0
  pushl $91
801064fc:	6a 5b                	push   $0x5b
  jmp alltraps
801064fe:	e9 9c f6 ff ff       	jmp    80105b9f <alltraps>

80106503 <vector92>:
.globl vector92
vector92:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $92
80106505:	6a 5c                	push   $0x5c
  jmp alltraps
80106507:	e9 93 f6 ff ff       	jmp    80105b9f <alltraps>

8010650c <vector93>:
.globl vector93
vector93:
  pushl $0
8010650c:	6a 00                	push   $0x0
  pushl $93
8010650e:	6a 5d                	push   $0x5d
  jmp alltraps
80106510:	e9 8a f6 ff ff       	jmp    80105b9f <alltraps>

80106515 <vector94>:
.globl vector94
vector94:
  pushl $0
80106515:	6a 00                	push   $0x0
  pushl $94
80106517:	6a 5e                	push   $0x5e
  jmp alltraps
80106519:	e9 81 f6 ff ff       	jmp    80105b9f <alltraps>

8010651e <vector95>:
.globl vector95
vector95:
  pushl $0
8010651e:	6a 00                	push   $0x0
  pushl $95
80106520:	6a 5f                	push   $0x5f
  jmp alltraps
80106522:	e9 78 f6 ff ff       	jmp    80105b9f <alltraps>

80106527 <vector96>:
.globl vector96
vector96:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $96
80106529:	6a 60                	push   $0x60
  jmp alltraps
8010652b:	e9 6f f6 ff ff       	jmp    80105b9f <alltraps>

80106530 <vector97>:
.globl vector97
vector97:
  pushl $0
80106530:	6a 00                	push   $0x0
  pushl $97
80106532:	6a 61                	push   $0x61
  jmp alltraps
80106534:	e9 66 f6 ff ff       	jmp    80105b9f <alltraps>

80106539 <vector98>:
.globl vector98
vector98:
  pushl $0
80106539:	6a 00                	push   $0x0
  pushl $98
8010653b:	6a 62                	push   $0x62
  jmp alltraps
8010653d:	e9 5d f6 ff ff       	jmp    80105b9f <alltraps>

80106542 <vector99>:
.globl vector99
vector99:
  pushl $0
80106542:	6a 00                	push   $0x0
  pushl $99
80106544:	6a 63                	push   $0x63
  jmp alltraps
80106546:	e9 54 f6 ff ff       	jmp    80105b9f <alltraps>

8010654b <vector100>:
.globl vector100
vector100:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $100
8010654d:	6a 64                	push   $0x64
  jmp alltraps
8010654f:	e9 4b f6 ff ff       	jmp    80105b9f <alltraps>

80106554 <vector101>:
.globl vector101
vector101:
  pushl $0
80106554:	6a 00                	push   $0x0
  pushl $101
80106556:	6a 65                	push   $0x65
  jmp alltraps
80106558:	e9 42 f6 ff ff       	jmp    80105b9f <alltraps>

8010655d <vector102>:
.globl vector102
vector102:
  pushl $0
8010655d:	6a 00                	push   $0x0
  pushl $102
8010655f:	6a 66                	push   $0x66
  jmp alltraps
80106561:	e9 39 f6 ff ff       	jmp    80105b9f <alltraps>

80106566 <vector103>:
.globl vector103
vector103:
  pushl $0
80106566:	6a 00                	push   $0x0
  pushl $103
80106568:	6a 67                	push   $0x67
  jmp alltraps
8010656a:	e9 30 f6 ff ff       	jmp    80105b9f <alltraps>

8010656f <vector104>:
.globl vector104
vector104:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $104
80106571:	6a 68                	push   $0x68
  jmp alltraps
80106573:	e9 27 f6 ff ff       	jmp    80105b9f <alltraps>

80106578 <vector105>:
.globl vector105
vector105:
  pushl $0
80106578:	6a 00                	push   $0x0
  pushl $105
8010657a:	6a 69                	push   $0x69
  jmp alltraps
8010657c:	e9 1e f6 ff ff       	jmp    80105b9f <alltraps>

80106581 <vector106>:
.globl vector106
vector106:
  pushl $0
80106581:	6a 00                	push   $0x0
  pushl $106
80106583:	6a 6a                	push   $0x6a
  jmp alltraps
80106585:	e9 15 f6 ff ff       	jmp    80105b9f <alltraps>

8010658a <vector107>:
.globl vector107
vector107:
  pushl $0
8010658a:	6a 00                	push   $0x0
  pushl $107
8010658c:	6a 6b                	push   $0x6b
  jmp alltraps
8010658e:	e9 0c f6 ff ff       	jmp    80105b9f <alltraps>

80106593 <vector108>:
.globl vector108
vector108:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $108
80106595:	6a 6c                	push   $0x6c
  jmp alltraps
80106597:	e9 03 f6 ff ff       	jmp    80105b9f <alltraps>

8010659c <vector109>:
.globl vector109
vector109:
  pushl $0
8010659c:	6a 00                	push   $0x0
  pushl $109
8010659e:	6a 6d                	push   $0x6d
  jmp alltraps
801065a0:	e9 fa f5 ff ff       	jmp    80105b9f <alltraps>

801065a5 <vector110>:
.globl vector110
vector110:
  pushl $0
801065a5:	6a 00                	push   $0x0
  pushl $110
801065a7:	6a 6e                	push   $0x6e
  jmp alltraps
801065a9:	e9 f1 f5 ff ff       	jmp    80105b9f <alltraps>

801065ae <vector111>:
.globl vector111
vector111:
  pushl $0
801065ae:	6a 00                	push   $0x0
  pushl $111
801065b0:	6a 6f                	push   $0x6f
  jmp alltraps
801065b2:	e9 e8 f5 ff ff       	jmp    80105b9f <alltraps>

801065b7 <vector112>:
.globl vector112
vector112:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $112
801065b9:	6a 70                	push   $0x70
  jmp alltraps
801065bb:	e9 df f5 ff ff       	jmp    80105b9f <alltraps>

801065c0 <vector113>:
.globl vector113
vector113:
  pushl $0
801065c0:	6a 00                	push   $0x0
  pushl $113
801065c2:	6a 71                	push   $0x71
  jmp alltraps
801065c4:	e9 d6 f5 ff ff       	jmp    80105b9f <alltraps>

801065c9 <vector114>:
.globl vector114
vector114:
  pushl $0
801065c9:	6a 00                	push   $0x0
  pushl $114
801065cb:	6a 72                	push   $0x72
  jmp alltraps
801065cd:	e9 cd f5 ff ff       	jmp    80105b9f <alltraps>

801065d2 <vector115>:
.globl vector115
vector115:
  pushl $0
801065d2:	6a 00                	push   $0x0
  pushl $115
801065d4:	6a 73                	push   $0x73
  jmp alltraps
801065d6:	e9 c4 f5 ff ff       	jmp    80105b9f <alltraps>

801065db <vector116>:
.globl vector116
vector116:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $116
801065dd:	6a 74                	push   $0x74
  jmp alltraps
801065df:	e9 bb f5 ff ff       	jmp    80105b9f <alltraps>

801065e4 <vector117>:
.globl vector117
vector117:
  pushl $0
801065e4:	6a 00                	push   $0x0
  pushl $117
801065e6:	6a 75                	push   $0x75
  jmp alltraps
801065e8:	e9 b2 f5 ff ff       	jmp    80105b9f <alltraps>

801065ed <vector118>:
.globl vector118
vector118:
  pushl $0
801065ed:	6a 00                	push   $0x0
  pushl $118
801065ef:	6a 76                	push   $0x76
  jmp alltraps
801065f1:	e9 a9 f5 ff ff       	jmp    80105b9f <alltraps>

801065f6 <vector119>:
.globl vector119
vector119:
  pushl $0
801065f6:	6a 00                	push   $0x0
  pushl $119
801065f8:	6a 77                	push   $0x77
  jmp alltraps
801065fa:	e9 a0 f5 ff ff       	jmp    80105b9f <alltraps>

801065ff <vector120>:
.globl vector120
vector120:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $120
80106601:	6a 78                	push   $0x78
  jmp alltraps
80106603:	e9 97 f5 ff ff       	jmp    80105b9f <alltraps>

80106608 <vector121>:
.globl vector121
vector121:
  pushl $0
80106608:	6a 00                	push   $0x0
  pushl $121
8010660a:	6a 79                	push   $0x79
  jmp alltraps
8010660c:	e9 8e f5 ff ff       	jmp    80105b9f <alltraps>

80106611 <vector122>:
.globl vector122
vector122:
  pushl $0
80106611:	6a 00                	push   $0x0
  pushl $122
80106613:	6a 7a                	push   $0x7a
  jmp alltraps
80106615:	e9 85 f5 ff ff       	jmp    80105b9f <alltraps>

8010661a <vector123>:
.globl vector123
vector123:
  pushl $0
8010661a:	6a 00                	push   $0x0
  pushl $123
8010661c:	6a 7b                	push   $0x7b
  jmp alltraps
8010661e:	e9 7c f5 ff ff       	jmp    80105b9f <alltraps>

80106623 <vector124>:
.globl vector124
vector124:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $124
80106625:	6a 7c                	push   $0x7c
  jmp alltraps
80106627:	e9 73 f5 ff ff       	jmp    80105b9f <alltraps>

8010662c <vector125>:
.globl vector125
vector125:
  pushl $0
8010662c:	6a 00                	push   $0x0
  pushl $125
8010662e:	6a 7d                	push   $0x7d
  jmp alltraps
80106630:	e9 6a f5 ff ff       	jmp    80105b9f <alltraps>

80106635 <vector126>:
.globl vector126
vector126:
  pushl $0
80106635:	6a 00                	push   $0x0
  pushl $126
80106637:	6a 7e                	push   $0x7e
  jmp alltraps
80106639:	e9 61 f5 ff ff       	jmp    80105b9f <alltraps>

8010663e <vector127>:
.globl vector127
vector127:
  pushl $0
8010663e:	6a 00                	push   $0x0
  pushl $127
80106640:	6a 7f                	push   $0x7f
  jmp alltraps
80106642:	e9 58 f5 ff ff       	jmp    80105b9f <alltraps>

80106647 <vector128>:
.globl vector128
vector128:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $128
80106649:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010664e:	e9 4c f5 ff ff       	jmp    80105b9f <alltraps>

80106653 <vector129>:
.globl vector129
vector129:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $129
80106655:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010665a:	e9 40 f5 ff ff       	jmp    80105b9f <alltraps>

8010665f <vector130>:
.globl vector130
vector130:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $130
80106661:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106666:	e9 34 f5 ff ff       	jmp    80105b9f <alltraps>

8010666b <vector131>:
.globl vector131
vector131:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $131
8010666d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106672:	e9 28 f5 ff ff       	jmp    80105b9f <alltraps>

80106677 <vector132>:
.globl vector132
vector132:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $132
80106679:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010667e:	e9 1c f5 ff ff       	jmp    80105b9f <alltraps>

80106683 <vector133>:
.globl vector133
vector133:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $133
80106685:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010668a:	e9 10 f5 ff ff       	jmp    80105b9f <alltraps>

8010668f <vector134>:
.globl vector134
vector134:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $134
80106691:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106696:	e9 04 f5 ff ff       	jmp    80105b9f <alltraps>

8010669b <vector135>:
.globl vector135
vector135:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $135
8010669d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801066a2:	e9 f8 f4 ff ff       	jmp    80105b9f <alltraps>

801066a7 <vector136>:
.globl vector136
vector136:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $136
801066a9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801066ae:	e9 ec f4 ff ff       	jmp    80105b9f <alltraps>

801066b3 <vector137>:
.globl vector137
vector137:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $137
801066b5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801066ba:	e9 e0 f4 ff ff       	jmp    80105b9f <alltraps>

801066bf <vector138>:
.globl vector138
vector138:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $138
801066c1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801066c6:	e9 d4 f4 ff ff       	jmp    80105b9f <alltraps>

801066cb <vector139>:
.globl vector139
vector139:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $139
801066cd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801066d2:	e9 c8 f4 ff ff       	jmp    80105b9f <alltraps>

801066d7 <vector140>:
.globl vector140
vector140:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $140
801066d9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801066de:	e9 bc f4 ff ff       	jmp    80105b9f <alltraps>

801066e3 <vector141>:
.globl vector141
vector141:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $141
801066e5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801066ea:	e9 b0 f4 ff ff       	jmp    80105b9f <alltraps>

801066ef <vector142>:
.globl vector142
vector142:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $142
801066f1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801066f6:	e9 a4 f4 ff ff       	jmp    80105b9f <alltraps>

801066fb <vector143>:
.globl vector143
vector143:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $143
801066fd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106702:	e9 98 f4 ff ff       	jmp    80105b9f <alltraps>

80106707 <vector144>:
.globl vector144
vector144:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $144
80106709:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010670e:	e9 8c f4 ff ff       	jmp    80105b9f <alltraps>

80106713 <vector145>:
.globl vector145
vector145:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $145
80106715:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010671a:	e9 80 f4 ff ff       	jmp    80105b9f <alltraps>

8010671f <vector146>:
.globl vector146
vector146:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $146
80106721:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106726:	e9 74 f4 ff ff       	jmp    80105b9f <alltraps>

8010672b <vector147>:
.globl vector147
vector147:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $147
8010672d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106732:	e9 68 f4 ff ff       	jmp    80105b9f <alltraps>

80106737 <vector148>:
.globl vector148
vector148:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $148
80106739:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010673e:	e9 5c f4 ff ff       	jmp    80105b9f <alltraps>

80106743 <vector149>:
.globl vector149
vector149:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $149
80106745:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010674a:	e9 50 f4 ff ff       	jmp    80105b9f <alltraps>

8010674f <vector150>:
.globl vector150
vector150:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $150
80106751:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106756:	e9 44 f4 ff ff       	jmp    80105b9f <alltraps>

8010675b <vector151>:
.globl vector151
vector151:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $151
8010675d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106762:	e9 38 f4 ff ff       	jmp    80105b9f <alltraps>

80106767 <vector152>:
.globl vector152
vector152:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $152
80106769:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010676e:	e9 2c f4 ff ff       	jmp    80105b9f <alltraps>

80106773 <vector153>:
.globl vector153
vector153:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $153
80106775:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010677a:	e9 20 f4 ff ff       	jmp    80105b9f <alltraps>

8010677f <vector154>:
.globl vector154
vector154:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $154
80106781:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106786:	e9 14 f4 ff ff       	jmp    80105b9f <alltraps>

8010678b <vector155>:
.globl vector155
vector155:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $155
8010678d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106792:	e9 08 f4 ff ff       	jmp    80105b9f <alltraps>

80106797 <vector156>:
.globl vector156
vector156:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $156
80106799:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010679e:	e9 fc f3 ff ff       	jmp    80105b9f <alltraps>

801067a3 <vector157>:
.globl vector157
vector157:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $157
801067a5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801067aa:	e9 f0 f3 ff ff       	jmp    80105b9f <alltraps>

801067af <vector158>:
.globl vector158
vector158:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $158
801067b1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801067b6:	e9 e4 f3 ff ff       	jmp    80105b9f <alltraps>

801067bb <vector159>:
.globl vector159
vector159:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $159
801067bd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801067c2:	e9 d8 f3 ff ff       	jmp    80105b9f <alltraps>

801067c7 <vector160>:
.globl vector160
vector160:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $160
801067c9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801067ce:	e9 cc f3 ff ff       	jmp    80105b9f <alltraps>

801067d3 <vector161>:
.globl vector161
vector161:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $161
801067d5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801067da:	e9 c0 f3 ff ff       	jmp    80105b9f <alltraps>

801067df <vector162>:
.globl vector162
vector162:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $162
801067e1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801067e6:	e9 b4 f3 ff ff       	jmp    80105b9f <alltraps>

801067eb <vector163>:
.globl vector163
vector163:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $163
801067ed:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801067f2:	e9 a8 f3 ff ff       	jmp    80105b9f <alltraps>

801067f7 <vector164>:
.globl vector164
vector164:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $164
801067f9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801067fe:	e9 9c f3 ff ff       	jmp    80105b9f <alltraps>

80106803 <vector165>:
.globl vector165
vector165:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $165
80106805:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010680a:	e9 90 f3 ff ff       	jmp    80105b9f <alltraps>

8010680f <vector166>:
.globl vector166
vector166:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $166
80106811:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106816:	e9 84 f3 ff ff       	jmp    80105b9f <alltraps>

8010681b <vector167>:
.globl vector167
vector167:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $167
8010681d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106822:	e9 78 f3 ff ff       	jmp    80105b9f <alltraps>

80106827 <vector168>:
.globl vector168
vector168:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $168
80106829:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010682e:	e9 6c f3 ff ff       	jmp    80105b9f <alltraps>

80106833 <vector169>:
.globl vector169
vector169:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $169
80106835:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010683a:	e9 60 f3 ff ff       	jmp    80105b9f <alltraps>

8010683f <vector170>:
.globl vector170
vector170:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $170
80106841:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106846:	e9 54 f3 ff ff       	jmp    80105b9f <alltraps>

8010684b <vector171>:
.globl vector171
vector171:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $171
8010684d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106852:	e9 48 f3 ff ff       	jmp    80105b9f <alltraps>

80106857 <vector172>:
.globl vector172
vector172:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $172
80106859:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010685e:	e9 3c f3 ff ff       	jmp    80105b9f <alltraps>

80106863 <vector173>:
.globl vector173
vector173:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $173
80106865:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010686a:	e9 30 f3 ff ff       	jmp    80105b9f <alltraps>

8010686f <vector174>:
.globl vector174
vector174:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $174
80106871:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106876:	e9 24 f3 ff ff       	jmp    80105b9f <alltraps>

8010687b <vector175>:
.globl vector175
vector175:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $175
8010687d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106882:	e9 18 f3 ff ff       	jmp    80105b9f <alltraps>

80106887 <vector176>:
.globl vector176
vector176:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $176
80106889:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010688e:	e9 0c f3 ff ff       	jmp    80105b9f <alltraps>

80106893 <vector177>:
.globl vector177
vector177:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $177
80106895:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010689a:	e9 00 f3 ff ff       	jmp    80105b9f <alltraps>

8010689f <vector178>:
.globl vector178
vector178:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $178
801068a1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801068a6:	e9 f4 f2 ff ff       	jmp    80105b9f <alltraps>

801068ab <vector179>:
.globl vector179
vector179:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $179
801068ad:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801068b2:	e9 e8 f2 ff ff       	jmp    80105b9f <alltraps>

801068b7 <vector180>:
.globl vector180
vector180:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $180
801068b9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801068be:	e9 dc f2 ff ff       	jmp    80105b9f <alltraps>

801068c3 <vector181>:
.globl vector181
vector181:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $181
801068c5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801068ca:	e9 d0 f2 ff ff       	jmp    80105b9f <alltraps>

801068cf <vector182>:
.globl vector182
vector182:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $182
801068d1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801068d6:	e9 c4 f2 ff ff       	jmp    80105b9f <alltraps>

801068db <vector183>:
.globl vector183
vector183:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $183
801068dd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801068e2:	e9 b8 f2 ff ff       	jmp    80105b9f <alltraps>

801068e7 <vector184>:
.globl vector184
vector184:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $184
801068e9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801068ee:	e9 ac f2 ff ff       	jmp    80105b9f <alltraps>

801068f3 <vector185>:
.globl vector185
vector185:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $185
801068f5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801068fa:	e9 a0 f2 ff ff       	jmp    80105b9f <alltraps>

801068ff <vector186>:
.globl vector186
vector186:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $186
80106901:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106906:	e9 94 f2 ff ff       	jmp    80105b9f <alltraps>

8010690b <vector187>:
.globl vector187
vector187:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $187
8010690d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106912:	e9 88 f2 ff ff       	jmp    80105b9f <alltraps>

80106917 <vector188>:
.globl vector188
vector188:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $188
80106919:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010691e:	e9 7c f2 ff ff       	jmp    80105b9f <alltraps>

80106923 <vector189>:
.globl vector189
vector189:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $189
80106925:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010692a:	e9 70 f2 ff ff       	jmp    80105b9f <alltraps>

8010692f <vector190>:
.globl vector190
vector190:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $190
80106931:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106936:	e9 64 f2 ff ff       	jmp    80105b9f <alltraps>

8010693b <vector191>:
.globl vector191
vector191:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $191
8010693d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106942:	e9 58 f2 ff ff       	jmp    80105b9f <alltraps>

80106947 <vector192>:
.globl vector192
vector192:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $192
80106949:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010694e:	e9 4c f2 ff ff       	jmp    80105b9f <alltraps>

80106953 <vector193>:
.globl vector193
vector193:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $193
80106955:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010695a:	e9 40 f2 ff ff       	jmp    80105b9f <alltraps>

8010695f <vector194>:
.globl vector194
vector194:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $194
80106961:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106966:	e9 34 f2 ff ff       	jmp    80105b9f <alltraps>

8010696b <vector195>:
.globl vector195
vector195:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $195
8010696d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106972:	e9 28 f2 ff ff       	jmp    80105b9f <alltraps>

80106977 <vector196>:
.globl vector196
vector196:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $196
80106979:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010697e:	e9 1c f2 ff ff       	jmp    80105b9f <alltraps>

80106983 <vector197>:
.globl vector197
vector197:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $197
80106985:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010698a:	e9 10 f2 ff ff       	jmp    80105b9f <alltraps>

8010698f <vector198>:
.globl vector198
vector198:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $198
80106991:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106996:	e9 04 f2 ff ff       	jmp    80105b9f <alltraps>

8010699b <vector199>:
.globl vector199
vector199:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $199
8010699d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801069a2:	e9 f8 f1 ff ff       	jmp    80105b9f <alltraps>

801069a7 <vector200>:
.globl vector200
vector200:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $200
801069a9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801069ae:	e9 ec f1 ff ff       	jmp    80105b9f <alltraps>

801069b3 <vector201>:
.globl vector201
vector201:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $201
801069b5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801069ba:	e9 e0 f1 ff ff       	jmp    80105b9f <alltraps>

801069bf <vector202>:
.globl vector202
vector202:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $202
801069c1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801069c6:	e9 d4 f1 ff ff       	jmp    80105b9f <alltraps>

801069cb <vector203>:
.globl vector203
vector203:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $203
801069cd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801069d2:	e9 c8 f1 ff ff       	jmp    80105b9f <alltraps>

801069d7 <vector204>:
.globl vector204
vector204:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $204
801069d9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801069de:	e9 bc f1 ff ff       	jmp    80105b9f <alltraps>

801069e3 <vector205>:
.globl vector205
vector205:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $205
801069e5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801069ea:	e9 b0 f1 ff ff       	jmp    80105b9f <alltraps>

801069ef <vector206>:
.globl vector206
vector206:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $206
801069f1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801069f6:	e9 a4 f1 ff ff       	jmp    80105b9f <alltraps>

801069fb <vector207>:
.globl vector207
vector207:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $207
801069fd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106a02:	e9 98 f1 ff ff       	jmp    80105b9f <alltraps>

80106a07 <vector208>:
.globl vector208
vector208:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $208
80106a09:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106a0e:	e9 8c f1 ff ff       	jmp    80105b9f <alltraps>

80106a13 <vector209>:
.globl vector209
vector209:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $209
80106a15:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106a1a:	e9 80 f1 ff ff       	jmp    80105b9f <alltraps>

80106a1f <vector210>:
.globl vector210
vector210:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $210
80106a21:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106a26:	e9 74 f1 ff ff       	jmp    80105b9f <alltraps>

80106a2b <vector211>:
.globl vector211
vector211:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $211
80106a2d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106a32:	e9 68 f1 ff ff       	jmp    80105b9f <alltraps>

80106a37 <vector212>:
.globl vector212
vector212:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $212
80106a39:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106a3e:	e9 5c f1 ff ff       	jmp    80105b9f <alltraps>

80106a43 <vector213>:
.globl vector213
vector213:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $213
80106a45:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106a4a:	e9 50 f1 ff ff       	jmp    80105b9f <alltraps>

80106a4f <vector214>:
.globl vector214
vector214:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $214
80106a51:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106a56:	e9 44 f1 ff ff       	jmp    80105b9f <alltraps>

80106a5b <vector215>:
.globl vector215
vector215:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $215
80106a5d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106a62:	e9 38 f1 ff ff       	jmp    80105b9f <alltraps>

80106a67 <vector216>:
.globl vector216
vector216:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $216
80106a69:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106a6e:	e9 2c f1 ff ff       	jmp    80105b9f <alltraps>

80106a73 <vector217>:
.globl vector217
vector217:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $217
80106a75:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106a7a:	e9 20 f1 ff ff       	jmp    80105b9f <alltraps>

80106a7f <vector218>:
.globl vector218
vector218:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $218
80106a81:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106a86:	e9 14 f1 ff ff       	jmp    80105b9f <alltraps>

80106a8b <vector219>:
.globl vector219
vector219:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $219
80106a8d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106a92:	e9 08 f1 ff ff       	jmp    80105b9f <alltraps>

80106a97 <vector220>:
.globl vector220
vector220:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $220
80106a99:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106a9e:	e9 fc f0 ff ff       	jmp    80105b9f <alltraps>

80106aa3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $221
80106aa5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106aaa:	e9 f0 f0 ff ff       	jmp    80105b9f <alltraps>

80106aaf <vector222>:
.globl vector222
vector222:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $222
80106ab1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106ab6:	e9 e4 f0 ff ff       	jmp    80105b9f <alltraps>

80106abb <vector223>:
.globl vector223
vector223:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $223
80106abd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106ac2:	e9 d8 f0 ff ff       	jmp    80105b9f <alltraps>

80106ac7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $224
80106ac9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106ace:	e9 cc f0 ff ff       	jmp    80105b9f <alltraps>

80106ad3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $225
80106ad5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106ada:	e9 c0 f0 ff ff       	jmp    80105b9f <alltraps>

80106adf <vector226>:
.globl vector226
vector226:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $226
80106ae1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106ae6:	e9 b4 f0 ff ff       	jmp    80105b9f <alltraps>

80106aeb <vector227>:
.globl vector227
vector227:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $227
80106aed:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106af2:	e9 a8 f0 ff ff       	jmp    80105b9f <alltraps>

80106af7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $228
80106af9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106afe:	e9 9c f0 ff ff       	jmp    80105b9f <alltraps>

80106b03 <vector229>:
.globl vector229
vector229:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $229
80106b05:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106b0a:	e9 90 f0 ff ff       	jmp    80105b9f <alltraps>

80106b0f <vector230>:
.globl vector230
vector230:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $230
80106b11:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106b16:	e9 84 f0 ff ff       	jmp    80105b9f <alltraps>

80106b1b <vector231>:
.globl vector231
vector231:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $231
80106b1d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106b22:	e9 78 f0 ff ff       	jmp    80105b9f <alltraps>

80106b27 <vector232>:
.globl vector232
vector232:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $232
80106b29:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106b2e:	e9 6c f0 ff ff       	jmp    80105b9f <alltraps>

80106b33 <vector233>:
.globl vector233
vector233:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $233
80106b35:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106b3a:	e9 60 f0 ff ff       	jmp    80105b9f <alltraps>

80106b3f <vector234>:
.globl vector234
vector234:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $234
80106b41:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106b46:	e9 54 f0 ff ff       	jmp    80105b9f <alltraps>

80106b4b <vector235>:
.globl vector235
vector235:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $235
80106b4d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106b52:	e9 48 f0 ff ff       	jmp    80105b9f <alltraps>

80106b57 <vector236>:
.globl vector236
vector236:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $236
80106b59:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106b5e:	e9 3c f0 ff ff       	jmp    80105b9f <alltraps>

80106b63 <vector237>:
.globl vector237
vector237:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $237
80106b65:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106b6a:	e9 30 f0 ff ff       	jmp    80105b9f <alltraps>

80106b6f <vector238>:
.globl vector238
vector238:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $238
80106b71:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106b76:	e9 24 f0 ff ff       	jmp    80105b9f <alltraps>

80106b7b <vector239>:
.globl vector239
vector239:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $239
80106b7d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106b82:	e9 18 f0 ff ff       	jmp    80105b9f <alltraps>

80106b87 <vector240>:
.globl vector240
vector240:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $240
80106b89:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106b8e:	e9 0c f0 ff ff       	jmp    80105b9f <alltraps>

80106b93 <vector241>:
.globl vector241
vector241:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $241
80106b95:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106b9a:	e9 00 f0 ff ff       	jmp    80105b9f <alltraps>

80106b9f <vector242>:
.globl vector242
vector242:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $242
80106ba1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106ba6:	e9 f4 ef ff ff       	jmp    80105b9f <alltraps>

80106bab <vector243>:
.globl vector243
vector243:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $243
80106bad:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106bb2:	e9 e8 ef ff ff       	jmp    80105b9f <alltraps>

80106bb7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $244
80106bb9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106bbe:	e9 dc ef ff ff       	jmp    80105b9f <alltraps>

80106bc3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $245
80106bc5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106bca:	e9 d0 ef ff ff       	jmp    80105b9f <alltraps>

80106bcf <vector246>:
.globl vector246
vector246:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $246
80106bd1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106bd6:	e9 c4 ef ff ff       	jmp    80105b9f <alltraps>

80106bdb <vector247>:
.globl vector247
vector247:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $247
80106bdd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106be2:	e9 b8 ef ff ff       	jmp    80105b9f <alltraps>

80106be7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $248
80106be9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106bee:	e9 ac ef ff ff       	jmp    80105b9f <alltraps>

80106bf3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $249
80106bf5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106bfa:	e9 a0 ef ff ff       	jmp    80105b9f <alltraps>

80106bff <vector250>:
.globl vector250
vector250:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $250
80106c01:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106c06:	e9 94 ef ff ff       	jmp    80105b9f <alltraps>

80106c0b <vector251>:
.globl vector251
vector251:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $251
80106c0d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106c12:	e9 88 ef ff ff       	jmp    80105b9f <alltraps>

80106c17 <vector252>:
.globl vector252
vector252:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $252
80106c19:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106c1e:	e9 7c ef ff ff       	jmp    80105b9f <alltraps>

80106c23 <vector253>:
.globl vector253
vector253:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $253
80106c25:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106c2a:	e9 70 ef ff ff       	jmp    80105b9f <alltraps>

80106c2f <vector254>:
.globl vector254
vector254:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $254
80106c31:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106c36:	e9 64 ef ff ff       	jmp    80105b9f <alltraps>

80106c3b <vector255>:
.globl vector255
vector255:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $255
80106c3d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106c42:	e9 58 ef ff ff       	jmp    80105b9f <alltraps>
80106c47:	66 90                	xchg   %ax,%ax
80106c49:	66 90                	xchg   %ax,%ax
80106c4b:	66 90                	xchg   %ax,%ax
80106c4d:	66 90                	xchg   %ax,%ax
80106c4f:	90                   	nop

80106c50 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c50:	55                   	push   %ebp
80106c51:	89 e5                	mov    %esp,%ebp
80106c53:	57                   	push   %edi
80106c54:	56                   	push   %esi
80106c55:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106c56:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106c5c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c62:	83 ec 1c             	sub    $0x1c,%esp
80106c65:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106c68:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106c6b:	39 d3                	cmp    %edx,%ebx
80106c6d:	73 50                	jae    80106cbf <deallocuvm.part.0+0x6f>
80106c6f:	89 c6                	mov    %eax,%esi
80106c71:	eb 12                	jmp    80106c85 <deallocuvm.part.0+0x35>
80106c73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106c77:	90                   	nop
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106c78:	83 c0 01             	add    $0x1,%eax
80106c7b:	c1 e0 16             	shl    $0x16,%eax
80106c7e:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106c80:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80106c83:	76 3a                	jbe    80106cbf <deallocuvm.part.0+0x6f>
  pde = &pgdir[PDX(va)];
80106c85:	89 d8                	mov    %ebx,%eax
80106c87:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106c8a:	8b 14 86             	mov    (%esi,%eax,4),%edx
80106c8d:	f6 c2 01             	test   $0x1,%dl
80106c90:	74 e6                	je     80106c78 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
80106c92:	89 df                	mov    %ebx,%edi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106c94:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106c9a:	c1 ef 0a             	shr    $0xa,%edi
80106c9d:	81 e7 fc 0f 00 00    	and    $0xffc,%edi
80106ca3:	8d bc 3a 00 00 00 80 	lea    -0x80000000(%edx,%edi,1),%edi
    if(!pte)
80106caa:	85 ff                	test   %edi,%edi
80106cac:	74 ca                	je     80106c78 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
80106cae:	8b 07                	mov    (%edi),%eax
80106cb0:	a8 01                	test   $0x1,%al
80106cb2:	75 1c                	jne    80106cd0 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
80106cb4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106cba:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80106cbd:	77 c6                	ja     80106c85 <deallocuvm.part.0+0x35>
	  kfree(v);
	  *pte = 0;
    }
  }
  return newsz;
}
80106cbf:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106cc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cc5:	5b                   	pop    %ebx
80106cc6:	5e                   	pop    %esi
80106cc7:	5f                   	pop    %edi
80106cc8:	5d                   	pop    %ebp
80106cc9:	c3                   	ret    
80106cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(pa == 0)
80106cd0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106cd5:	74 57                	je     80106d2e <deallocuvm.part.0+0xde>
}

unsigned char
get_count(uint pa)
{
  acquire(&cow_lock);
80106cd7:	83 ec 0c             	sub    $0xc,%esp
80106cda:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106cdd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  acquire(&cow_lock);
80106ce3:	68 00 b6 21 80       	push   $0x8021b600
80106ce8:	e8 f3 d9 ff ff       	call   801046e0 <acquire>
  uint index = PPN(pa);
  release(&cow_lock);
80106ced:	c7 04 24 00 b6 21 80 	movl   $0x8021b600,(%esp)
80106cf4:	e8 87 d9 ff ff       	call   80104680 <release>
  uint index = PPN(pa);
80106cf9:	8b 55 e0             	mov    -0x20(%ebp),%edx
	  if(get_count(pa) > 0) continue;
80106cfc:	83 c4 10             	add    $0x10,%esp
  uint index = PPN(pa);
80106cff:	89 d0                	mov    %edx,%eax
80106d01:	c1 e8 0c             	shr    $0xc,%eax
	  if(get_count(pa) > 0) continue;
80106d04:	80 b8 a0 37 11 80 00 	cmpb   $0x0,-0x7feec860(%eax)
80106d0b:	0f 85 6f ff ff ff    	jne    80106c80 <deallocuvm.part.0+0x30>
	  kfree(v);
80106d11:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106d14:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
	  kfree(v);
80106d1a:	50                   	push   %eax
80106d1b:	e8 b0 b7 ff ff       	call   801024d0 <kfree>
	  *pte = 0;
80106d20:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80106d26:	83 c4 10             	add    $0x10,%esp
80106d29:	e9 52 ff ff ff       	jmp    80106c80 <deallocuvm.part.0+0x30>
        panic("kfree");
80106d2e:	83 ec 0c             	sub    $0xc,%esp
80106d31:	68 e9 91 10 80       	push   $0x801091e9
80106d36:	e8 45 96 ff ff       	call   80100380 <panic>
80106d3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d3f:	90                   	nop

80106d40 <mappages>:
{
80106d40:	55                   	push   %ebp
80106d41:	89 e5                	mov    %esp,%ebp
80106d43:	57                   	push   %edi
80106d44:	56                   	push   %esi
80106d45:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106d46:	89 d3                	mov    %edx,%ebx
80106d48:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106d4e:	83 ec 1c             	sub    $0x1c,%esp
80106d51:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106d54:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106d58:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d5d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106d60:	8b 45 08             	mov    0x8(%ebp),%eax
80106d63:	29 d8                	sub    %ebx,%eax
80106d65:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106d68:	eb 3d                	jmp    80106da7 <mappages+0x67>
80106d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106d70:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106d72:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106d77:	c1 ea 0a             	shr    $0xa,%edx
80106d7a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106d80:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106d87:	85 c0                	test   %eax,%eax
80106d89:	74 75                	je     80106e00 <mappages+0xc0>
    if(*pte & PTE_P)
80106d8b:	f6 00 01             	testb  $0x1,(%eax)
80106d8e:	0f 85 86 00 00 00    	jne    80106e1a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106d94:	0b 75 0c             	or     0xc(%ebp),%esi
80106d97:	83 ce 01             	or     $0x1,%esi
80106d9a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106d9c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106d9f:	74 6f                	je     80106e10 <mappages+0xd0>
    a += PGSIZE;
80106da1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106da7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106daa:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106dad:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106db0:	89 d8                	mov    %ebx,%eax
80106db2:	c1 e8 16             	shr    $0x16,%eax
80106db5:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106db8:	8b 07                	mov    (%edi),%eax
80106dba:	a8 01                	test   $0x1,%al
80106dbc:	75 b2                	jne    80106d70 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106dbe:	e8 cd b8 ff ff       	call   80102690 <kalloc>
80106dc3:	85 c0                	test   %eax,%eax
80106dc5:	74 39                	je     80106e00 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106dc7:	83 ec 04             	sub    $0x4,%esp
80106dca:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106dcd:	68 00 10 00 00       	push   $0x1000
80106dd2:	6a 00                	push   $0x0
80106dd4:	50                   	push   %eax
80106dd5:	e8 c6 d9 ff ff       	call   801047a0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106dda:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106ddd:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106de0:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106de6:	83 c8 07             	or     $0x7,%eax
80106de9:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106deb:	89 d8                	mov    %ebx,%eax
80106ded:	c1 e8 0a             	shr    $0xa,%eax
80106df0:	25 fc 0f 00 00       	and    $0xffc,%eax
80106df5:	01 d0                	add    %edx,%eax
80106df7:	eb 92                	jmp    80106d8b <mappages+0x4b>
80106df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106e00:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106e03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e08:	5b                   	pop    %ebx
80106e09:	5e                   	pop    %esi
80106e0a:	5f                   	pop    %edi
80106e0b:	5d                   	pop    %ebp
80106e0c:	c3                   	ret    
80106e0d:	8d 76 00             	lea    0x0(%esi),%esi
80106e10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106e13:	31 c0                	xor    %eax,%eax
}
80106e15:	5b                   	pop    %ebx
80106e16:	5e                   	pop    %esi
80106e17:	5f                   	pop    %edi
80106e18:	5d                   	pop    %ebp
80106e19:	c3                   	ret    
      panic("remap");
80106e1a:	83 ec 0c             	sub    $0xc,%esp
80106e1d:	68 9c 90 10 80       	push   $0x8010909c
80106e22:	e8 59 95 ff ff       	call   80100380 <panic>
80106e27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e2e:	66 90                	xchg   %ax,%ax

80106e30 <init_cow>:
{
80106e30:	55                   	push   %ebp
80106e31:	89 e5                	mov    %esp,%ebp
80106e33:	83 ec 10             	sub    $0x10,%esp
  initlock(&cow_lock, "cow_lock");
80106e36:	68 a2 90 10 80       	push   $0x801090a2
80106e3b:	68 00 b6 21 80       	push   $0x8021b600
80106e40:	e8 cb d6 ff ff       	call   80104510 <initlock>
  memset(cow_ref_counts, 0, 1*1024*1024);
80106e45:	83 c4 0c             	add    $0xc,%esp
80106e48:	68 00 00 10 00       	push   $0x100000
80106e4d:	6a 00                	push   $0x0
80106e4f:	68 a0 37 11 80       	push   $0x801137a0
80106e54:	e8 47 d9 ff ff       	call   801047a0 <memset>
}
80106e59:	83 c4 10             	add    $0x10,%esp
80106e5c:	c9                   	leave  
80106e5d:	c3                   	ret    
80106e5e:	66 90                	xchg   %ax,%ax

80106e60 <seginit>:
{
80106e60:	55                   	push   %ebp
80106e61:	89 e5                	mov    %esp,%ebp
80106e63:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106e66:	e8 55 cb ff ff       	call   801039c0 <cpuid>
  pd[0] = size-1;
80106e6b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106e70:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106e76:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106e7a:	c7 80 38 38 21 80 ff 	movl   $0xffff,-0x7fdec7c8(%eax)
80106e81:	ff 00 00 
80106e84:	c7 80 3c 38 21 80 00 	movl   $0xcf9a00,-0x7fdec7c4(%eax)
80106e8b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106e8e:	c7 80 40 38 21 80 ff 	movl   $0xffff,-0x7fdec7c0(%eax)
80106e95:	ff 00 00 
80106e98:	c7 80 44 38 21 80 00 	movl   $0xcf9200,-0x7fdec7bc(%eax)
80106e9f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106ea2:	c7 80 48 38 21 80 ff 	movl   $0xffff,-0x7fdec7b8(%eax)
80106ea9:	ff 00 00 
80106eac:	c7 80 4c 38 21 80 00 	movl   $0xcffa00,-0x7fdec7b4(%eax)
80106eb3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106eb6:	c7 80 50 38 21 80 ff 	movl   $0xffff,-0x7fdec7b0(%eax)
80106ebd:	ff 00 00 
80106ec0:	c7 80 54 38 21 80 00 	movl   $0xcff200,-0x7fdec7ac(%eax)
80106ec7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106eca:	05 30 38 21 80       	add    $0x80213830,%eax
  pd[1] = (uint)p;
80106ecf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106ed3:	c1 e8 10             	shr    $0x10,%eax
80106ed6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106eda:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106edd:	0f 01 10             	lgdtl  (%eax)
}
80106ee0:	c9                   	leave  
80106ee1:	c3                   	ret    
80106ee2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ef0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106ef0:	a1 34 b6 21 80       	mov    0x8021b634,%eax
80106ef5:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106efa:	0f 22 d8             	mov    %eax,%cr3
}
80106efd:	c3                   	ret    
80106efe:	66 90                	xchg   %ax,%ax

80106f00 <switchuvm>:
{
80106f00:	55                   	push   %ebp
80106f01:	89 e5                	mov    %esp,%ebp
80106f03:	57                   	push   %edi
80106f04:	56                   	push   %esi
80106f05:	53                   	push   %ebx
80106f06:	83 ec 1c             	sub    $0x1c,%esp
80106f09:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106f0c:	85 f6                	test   %esi,%esi
80106f0e:	0f 84 cb 00 00 00    	je     80106fdf <switchuvm+0xdf>
  if(p->kstack == 0)
80106f14:	8b 46 08             	mov    0x8(%esi),%eax
80106f17:	85 c0                	test   %eax,%eax
80106f19:	0f 84 da 00 00 00    	je     80106ff9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106f1f:	8b 46 04             	mov    0x4(%esi),%eax
80106f22:	85 c0                	test   %eax,%eax
80106f24:	0f 84 c2 00 00 00    	je     80106fec <switchuvm+0xec>
  pushcli();
80106f2a:	e8 61 d6 ff ff       	call   80104590 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f2f:	e8 2c ca ff ff       	call   80103960 <mycpu>
80106f34:	89 c3                	mov    %eax,%ebx
80106f36:	e8 25 ca ff ff       	call   80103960 <mycpu>
80106f3b:	89 c7                	mov    %eax,%edi
80106f3d:	e8 1e ca ff ff       	call   80103960 <mycpu>
80106f42:	83 c7 08             	add    $0x8,%edi
80106f45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f48:	e8 13 ca ff ff       	call   80103960 <mycpu>
80106f4d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106f50:	ba 67 00 00 00       	mov    $0x67,%edx
80106f55:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106f5c:	83 c0 08             	add    $0x8,%eax
80106f5f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f66:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f6b:	83 c1 08             	add    $0x8,%ecx
80106f6e:	c1 e8 18             	shr    $0x18,%eax
80106f71:	c1 e9 10             	shr    $0x10,%ecx
80106f74:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106f7a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106f80:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106f85:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f8c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106f91:	e8 ca c9 ff ff       	call   80103960 <mycpu>
80106f96:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f9d:	e8 be c9 ff ff       	call   80103960 <mycpu>
80106fa2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106fa6:	8b 5e 08             	mov    0x8(%esi),%ebx
80106fa9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106faf:	e8 ac c9 ff ff       	call   80103960 <mycpu>
80106fb4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106fb7:	e8 a4 c9 ff ff       	call   80103960 <mycpu>
80106fbc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106fc0:	b8 28 00 00 00       	mov    $0x28,%eax
80106fc5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106fc8:	8b 46 04             	mov    0x4(%esi),%eax
80106fcb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106fd0:	0f 22 d8             	mov    %eax,%cr3
}
80106fd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fd6:	5b                   	pop    %ebx
80106fd7:	5e                   	pop    %esi
80106fd8:	5f                   	pop    %edi
80106fd9:	5d                   	pop    %ebp
  popcli();
80106fda:	e9 01 d6 ff ff       	jmp    801045e0 <popcli>
    panic("switchuvm: no process");
80106fdf:	83 ec 0c             	sub    $0xc,%esp
80106fe2:	68 ab 90 10 80       	push   $0x801090ab
80106fe7:	e8 94 93 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106fec:	83 ec 0c             	sub    $0xc,%esp
80106fef:	68 d6 90 10 80       	push   $0x801090d6
80106ff4:	e8 87 93 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106ff9:	83 ec 0c             	sub    $0xc,%esp
80106ffc:	68 c1 90 10 80       	push   $0x801090c1
80107001:	e8 7a 93 ff ff       	call   80100380 <panic>
80107006:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010700d:	8d 76 00             	lea    0x0(%esi),%esi

80107010 <inituvm>:
{
80107010:	55                   	push   %ebp
80107011:	89 e5                	mov    %esp,%ebp
80107013:	57                   	push   %edi
80107014:	56                   	push   %esi
80107015:	53                   	push   %ebx
80107016:	83 ec 1c             	sub    $0x1c,%esp
80107019:	8b 45 08             	mov    0x8(%ebp),%eax
8010701c:	8b 7d 10             	mov    0x10(%ebp),%edi
8010701f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107022:	8b 45 0c             	mov    0xc(%ebp),%eax
80107025:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(sz >= PGSIZE)
80107028:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
8010702e:	77 6a                	ja     8010709a <inituvm+0x8a>
  mem = kalloc();
80107030:	e8 5b b6 ff ff       	call   80102690 <kalloc>
  memset(mem, 0, PGSIZE);
80107035:	83 ec 04             	sub    $0x4,%esp
80107038:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010703d:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010703f:	6a 00                	push   $0x0
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107041:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  memset(mem, 0, PGSIZE);
80107047:	50                   	push   %eax
80107048:	e8 53 d7 ff ff       	call   801047a0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
8010704d:	58                   	pop    %eax
8010704e:	5a                   	pop    %edx
8010704f:	6a 06                	push   $0x6
80107051:	56                   	push   %esi
80107052:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107055:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010705a:	31 d2                	xor    %edx,%edx
  uint index = PPN(pa);
8010705c:	c1 ee 0c             	shr    $0xc,%esi
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
8010705f:	e8 dc fc ff ff       	call   80106d40 <mappages>
  memmove(mem, init, sz);
80107064:	83 c4 0c             	add    $0xc,%esp
80107067:	57                   	push   %edi
80107068:	ff 75 e0             	push   -0x20(%ebp)
8010706b:	53                   	push   %ebx
8010706c:	e8 cf d7 ff ff       	call   80104840 <memmove>
  acquire(&cow_lock);
80107071:	c7 04 24 00 b6 21 80 	movl   $0x8021b600,(%esp)
80107078:	e8 63 d6 ff ff       	call   801046e0 <acquire>
  cow_ref_counts[index] = count;
8010707d:	c6 86 a0 37 11 80 01 	movb   $0x1,-0x7feec860(%esi)
  release(&cow_lock);
80107084:	83 c4 10             	add    $0x10,%esp
80107087:	c7 45 08 00 b6 21 80 	movl   $0x8021b600,0x8(%ebp)
}
8010708e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107091:	5b                   	pop    %ebx
80107092:	5e                   	pop    %esi
80107093:	5f                   	pop    %edi
80107094:	5d                   	pop    %ebp
  release(&cow_lock);
80107095:	e9 e6 d5 ff ff       	jmp    80104680 <release>
    panic("inituvm: more than a page");
8010709a:	83 ec 0c             	sub    $0xc,%esp
8010709d:	68 ea 90 10 80       	push   $0x801090ea
801070a2:	e8 d9 92 ff ff       	call   80100380 <panic>
801070a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070ae:	66 90                	xchg   %ax,%ax

801070b0 <loaduvm>:
{
801070b0:	55                   	push   %ebp
801070b1:	89 e5                	mov    %esp,%ebp
801070b3:	57                   	push   %edi
801070b4:	56                   	push   %esi
801070b5:	53                   	push   %ebx
801070b6:	83 ec 1c             	sub    $0x1c,%esp
801070b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  if((uint) addr % PGSIZE != 0)
801070bc:	a9 ff 0f 00 00       	test   $0xfff,%eax
801070c1:	0f 85 ce 00 00 00    	jne    80107195 <loaduvm+0xe5>
  for(i = 0; i < sz; i += PGSIZE){
801070c7:	8b 5d 18             	mov    0x18(%ebp),%ebx
801070ca:	01 d8                	add    %ebx,%eax
801070cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801070cf:	8b 45 14             	mov    0x14(%ebp),%eax
801070d2:	01 d8                	add    %ebx,%eax
801070d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801070d7:	85 db                	test   %ebx,%ebx
801070d9:	0f 84 9a 00 00 00    	je     80107179 <loaduvm+0xc9>
801070df:	90                   	nop
  pde = &pgdir[PDX(va)];
801070e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
801070e3:	8b 7d 08             	mov    0x8(%ebp),%edi
801070e6:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
801070e8:	89 c2                	mov    %eax,%edx
801070ea:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801070ed:	8b 14 97             	mov    (%edi,%edx,4),%edx
801070f0:	f6 c2 01             	test   $0x1,%dl
801070f3:	75 13                	jne    80107108 <loaduvm+0x58>
      panic("loaduvm: address should exist");
801070f5:	83 ec 0c             	sub    $0xc,%esp
801070f8:	68 04 91 10 80       	push   $0x80109104
801070fd:	e8 7e 92 ff ff       	call   80100380 <panic>
80107102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107108:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010710b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107111:	25 fc 0f 00 00       	and    $0xffc,%eax
80107116:	8d bc 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%edi
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010711d:	85 ff                	test   %edi,%edi
8010711f:	74 d4                	je     801070f5 <loaduvm+0x45>
    pa = PTE_ADDR(*pte);
80107121:	8b 07                	mov    (%edi),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107123:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80107126:	be 00 10 00 00       	mov    $0x1000,%esi
    pa = PTE_ADDR(*pte);
8010712b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107130:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80107136:	0f 46 f3             	cmovbe %ebx,%esi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107139:	29 d9                	sub    %ebx,%ecx
8010713b:	05 00 00 00 80       	add    $0x80000000,%eax
80107140:	56                   	push   %esi
80107141:	51                   	push   %ecx
80107142:	50                   	push   %eax
80107143:	ff 75 10             	push   0x10(%ebp)
80107146:	e8 55 a9 ff ff       	call   80101aa0 <readi>
8010714b:	83 c4 10             	add    $0x10,%esp
8010714e:	39 f0                	cmp    %esi,%eax
80107150:	75 36                	jne    80107188 <loaduvm+0xd8>
	*pte &= ~PTE_W;
80107152:	8b 07                	mov    (%edi),%eax
80107154:	89 c2                	mov    %eax,%edx
80107156:	83 c8 02             	or     $0x2,%eax
80107159:	83 e2 fd             	and    $0xfffffffd,%edx
8010715c:	f6 45 1c 02          	testb  $0x2,0x1c(%ebp)
80107160:	0f 45 d0             	cmovne %eax,%edx
  for(i = 0; i < sz; i += PGSIZE){
80107163:	8b 45 18             	mov    0x18(%ebp),%eax
80107166:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
	*pte &= ~PTE_W;
8010716c:	89 17                	mov    %edx,(%edi)
  for(i = 0; i < sz; i += PGSIZE){
8010716e:	29 d8                	sub    %ebx,%eax
80107170:	39 45 18             	cmp    %eax,0x18(%ebp)
80107173:	0f 87 67 ff ff ff    	ja     801070e0 <loaduvm+0x30>
}
80107179:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010717c:	31 c0                	xor    %eax,%eax
}
8010717e:	5b                   	pop    %ebx
8010717f:	5e                   	pop    %esi
80107180:	5f                   	pop    %edi
80107181:	5d                   	pop    %ebp
80107182:	c3                   	ret    
80107183:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107187:	90                   	nop
80107188:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010718b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107190:	5b                   	pop    %ebx
80107191:	5e                   	pop    %esi
80107192:	5f                   	pop    %edi
80107193:	5d                   	pop    %ebp
80107194:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80107195:	83 ec 0c             	sub    $0xc,%esp
80107198:	68 24 92 10 80       	push   $0x80109224
8010719d:	e8 de 91 ff ff       	call   80100380 <panic>
801071a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801071b0 <allocuvm>:
{
801071b0:	55                   	push   %ebp
801071b1:	89 e5                	mov    %esp,%ebp
801071b3:	57                   	push   %edi
801071b4:	56                   	push   %esi
801071b5:	53                   	push   %ebx
801071b6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801071b9:	8b 45 10             	mov    0x10(%ebp),%eax
801071bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801071bf:	85 c0                	test   %eax,%eax
801071c1:	0f 88 e9 00 00 00    	js     801072b0 <allocuvm+0x100>
  if(newsz < oldsz)
801071c7:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801071ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801071cd:	0f 82 cd 00 00 00    	jb     801072a0 <allocuvm+0xf0>
  a = PGROUNDUP(oldsz);
801071d3:	8d b8 ff 0f 00 00    	lea    0xfff(%eax),%edi
801071d9:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  for(; a < newsz; a += PGSIZE){
801071df:	39 7d 10             	cmp    %edi,0x10(%ebp)
801071e2:	77 72                	ja     80107256 <allocuvm+0xa6>
801071e4:	e9 ba 00 00 00       	jmp    801072a3 <allocuvm+0xf3>
801071e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
801071f0:	83 ec 04             	sub    $0x4,%esp
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801071f3:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
    memset(mem, 0, PGSIZE);
801071f9:	68 00 10 00 00       	push   $0x1000
801071fe:	6a 00                	push   $0x0
80107200:	50                   	push   %eax
80107201:	e8 9a d5 ff ff       	call   801047a0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107206:	58                   	pop    %eax
80107207:	5a                   	pop    %edx
80107208:	6a 06                	push   $0x6
8010720a:	56                   	push   %esi
8010720b:	8b 45 08             	mov    0x8(%ebp),%eax
8010720e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107213:	89 fa                	mov    %edi,%edx
80107215:	e8 26 fb ff ff       	call   80106d40 <mappages>
8010721a:	83 c4 10             	add    $0x10,%esp
8010721d:	85 c0                	test   %eax,%eax
8010721f:	0f 88 a3 00 00 00    	js     801072c8 <allocuvm+0x118>
  acquire(&cow_lock);
80107225:	83 ec 0c             	sub    $0xc,%esp
  uint index = PPN(pa);
80107228:	c1 ee 0c             	shr    $0xc,%esi
  for(; a < newsz; a += PGSIZE){
8010722b:	81 c7 00 10 00 00    	add    $0x1000,%edi
  acquire(&cow_lock);
80107231:	68 00 b6 21 80       	push   $0x8021b600
80107236:	e8 a5 d4 ff ff       	call   801046e0 <acquire>
  release(&cow_lock);
8010723b:	c7 04 24 00 b6 21 80 	movl   $0x8021b600,(%esp)
  cow_ref_counts[index] = count;
80107242:	c6 86 a0 37 11 80 01 	movb   $0x1,-0x7feec860(%esi)
  release(&cow_lock);
80107249:	e8 32 d4 ff ff       	call   80104680 <release>
  for(; a < newsz; a += PGSIZE){
8010724e:	83 c4 10             	add    $0x10,%esp
80107251:	39 7d 10             	cmp    %edi,0x10(%ebp)
80107254:	76 4d                	jbe    801072a3 <allocuvm+0xf3>
    mem = kalloc();
80107256:	e8 35 b4 ff ff       	call   80102690 <kalloc>
8010725b:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
8010725d:	85 c0                	test   %eax,%eax
8010725f:	75 8f                	jne    801071f0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107261:	83 ec 0c             	sub    $0xc,%esp
80107264:	68 22 91 10 80       	push   $0x80109122
80107269:	e8 32 94 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
8010726e:	8b 45 0c             	mov    0xc(%ebp),%eax
80107271:	83 c4 10             	add    $0x10,%esp
80107274:	39 45 10             	cmp    %eax,0x10(%ebp)
80107277:	74 37                	je     801072b0 <allocuvm+0x100>
80107279:	8b 55 10             	mov    0x10(%ebp),%edx
8010727c:	89 c1                	mov    %eax,%ecx
8010727e:	8b 45 08             	mov    0x8(%ebp),%eax
80107281:	e8 ca f9 ff ff       	call   80106c50 <deallocuvm.part.0>
      return 0;
80107286:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
8010728d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107290:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107293:	5b                   	pop    %ebx
80107294:	5e                   	pop    %esi
80107295:	5f                   	pop    %edi
80107296:	5d                   	pop    %ebp
80107297:	c3                   	ret    
80107298:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010729f:	90                   	nop
    return oldsz;
801072a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801072a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072a9:	5b                   	pop    %ebx
801072aa:	5e                   	pop    %esi
801072ab:	5f                   	pop    %edi
801072ac:	5d                   	pop    %ebp
801072ad:	c3                   	ret    
801072ae:	66 90                	xchg   %ax,%ax
    return 0;
801072b0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801072b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072bd:	5b                   	pop    %ebx
801072be:	5e                   	pop    %esi
801072bf:	5f                   	pop    %edi
801072c0:	5d                   	pop    %ebp
801072c1:	c3                   	ret    
801072c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801072c8:	83 ec 0c             	sub    $0xc,%esp
801072cb:	68 3a 91 10 80       	push   $0x8010913a
801072d0:	e8 cb 93 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801072d5:	8b 45 0c             	mov    0xc(%ebp),%eax
801072d8:	83 c4 10             	add    $0x10,%esp
801072db:	39 45 10             	cmp    %eax,0x10(%ebp)
801072de:	74 0d                	je     801072ed <allocuvm+0x13d>
801072e0:	89 c1                	mov    %eax,%ecx
801072e2:	8b 55 10             	mov    0x10(%ebp),%edx
801072e5:	8b 45 08             	mov    0x8(%ebp),%eax
801072e8:	e8 63 f9 ff ff       	call   80106c50 <deallocuvm.part.0>
      kfree(mem);
801072ed:	83 ec 0c             	sub    $0xc,%esp
801072f0:	53                   	push   %ebx
801072f1:	e8 da b1 ff ff       	call   801024d0 <kfree>
      return 0;
801072f6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801072fd:	83 c4 10             	add    $0x10,%esp
}
80107300:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107303:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107306:	5b                   	pop    %ebx
80107307:	5e                   	pop    %esi
80107308:	5f                   	pop    %edi
80107309:	5d                   	pop    %ebp
8010730a:	c3                   	ret    
8010730b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010730f:	90                   	nop

80107310 <deallocuvm>:
{
80107310:	55                   	push   %ebp
80107311:	89 e5                	mov    %esp,%ebp
80107313:	8b 55 0c             	mov    0xc(%ebp),%edx
80107316:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107319:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010731c:	39 d1                	cmp    %edx,%ecx
8010731e:	73 10                	jae    80107330 <deallocuvm+0x20>
}
80107320:	5d                   	pop    %ebp
80107321:	e9 2a f9 ff ff       	jmp    80106c50 <deallocuvm.part.0>
80107326:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010732d:	8d 76 00             	lea    0x0(%esi),%esi
80107330:	89 d0                	mov    %edx,%eax
80107332:	5d                   	pop    %ebp
80107333:	c3                   	ret    
80107334:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010733b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010733f:	90                   	nop

80107340 <freevm>:
{
80107340:	55                   	push   %ebp
80107341:	89 e5                	mov    %esp,%ebp
80107343:	57                   	push   %edi
80107344:	56                   	push   %esi
80107345:	53                   	push   %ebx
80107346:	83 ec 1c             	sub    $0x1c,%esp
80107349:	8b 45 08             	mov    0x8(%ebp),%eax
8010734c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pgdir == 0)
8010734f:	85 c0                	test   %eax,%eax
80107351:	0f 84 8d 00 00 00    	je     801073e4 <freevm+0xa4>
  if(newsz >= oldsz)
80107357:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010735a:	31 c9                	xor    %ecx,%ecx
8010735c:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107361:	89 f0                	mov    %esi,%eax
80107363:	89 f3                	mov    %esi,%ebx
80107365:	8d b6 00 10 00 00    	lea    0x1000(%esi),%esi
8010736b:	e8 e0 f8 ff ff       	call   80106c50 <deallocuvm.part.0>
  for(i = 0; i < NPDENTRIES; i++){
80107370:	eb 0d                	jmp    8010737f <freevm+0x3f>
80107372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107378:	83 c3 04             	add    $0x4,%ebx
8010737b:	39 f3                	cmp    %esi,%ebx
8010737d:	74 53                	je     801073d2 <freevm+0x92>
    if(pgdir[i] & PTE_P){
8010737f:	8b 3b                	mov    (%ebx),%edi
80107381:	f7 c7 01 00 00 00    	test   $0x1,%edi
80107387:	74 ef                	je     80107378 <freevm+0x38>
  acquire(&cow_lock);
80107389:	83 ec 0c             	sub    $0xc,%esp
8010738c:	68 00 b6 21 80       	push   $0x8021b600
80107391:	e8 4a d3 ff ff       	call   801046e0 <acquire>
  release(&cow_lock);
80107396:	c7 04 24 00 b6 21 80 	movl   $0x8021b600,(%esp)
8010739d:	e8 de d2 ff ff       	call   80104680 <release>
  return cow_ref_counts[index];
801073a2:	89 f8                	mov    %edi,%eax
	  if(get_count(PTE_ADDR(pgdir[i])) > 0) continue;
801073a4:	83 c4 10             	add    $0x10,%esp
  return cow_ref_counts[index];
801073a7:	c1 e8 0c             	shr    $0xc,%eax
	  if(get_count(PTE_ADDR(pgdir[i])) > 0) continue;
801073aa:	80 b8 a0 37 11 80 00 	cmpb   $0x0,-0x7feec860(%eax)
801073b1:	75 c5                	jne    80107378 <freevm+0x38>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801073b3:	8b 03                	mov    (%ebx),%eax
	  kfree(v);
801073b5:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801073b8:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801073bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801073c0:	05 00 00 00 80       	add    $0x80000000,%eax
	  kfree(v);
801073c5:	50                   	push   %eax
801073c6:	e8 05 b1 ff ff       	call   801024d0 <kfree>
801073cb:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801073ce:	39 f3                	cmp    %esi,%ebx
801073d0:	75 ad                	jne    8010737f <freevm+0x3f>
  kfree((char*)pgdir);
801073d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801073d5:	89 45 08             	mov    %eax,0x8(%ebp)
}
801073d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073db:	5b                   	pop    %ebx
801073dc:	5e                   	pop    %esi
801073dd:	5f                   	pop    %edi
801073de:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801073df:	e9 ec b0 ff ff       	jmp    801024d0 <kfree>
    panic("freevm: no pgdir");
801073e4:	83 ec 0c             	sub    $0xc,%esp
801073e7:	68 56 91 10 80       	push   $0x80109156
801073ec:	e8 8f 8f ff ff       	call   80100380 <panic>
801073f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073ff:	90                   	nop

80107400 <setupkvm>:
{
80107400:	55                   	push   %ebp
80107401:	89 e5                	mov    %esp,%ebp
80107403:	56                   	push   %esi
80107404:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107405:	e8 86 b2 ff ff       	call   80102690 <kalloc>
8010740a:	89 c6                	mov    %eax,%esi
8010740c:	85 c0                	test   %eax,%eax
8010740e:	74 42                	je     80107452 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107410:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107413:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
80107418:	68 00 10 00 00       	push   $0x1000
8010741d:	6a 00                	push   $0x0
8010741f:	50                   	push   %eax
80107420:	e8 7b d3 ff ff       	call   801047a0 <memset>
80107425:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107428:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010742b:	83 ec 08             	sub    $0x8,%esp
8010742e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107431:	ff 73 0c             	push   0xc(%ebx)
80107434:	8b 13                	mov    (%ebx),%edx
80107436:	50                   	push   %eax
80107437:	29 c1                	sub    %eax,%ecx
80107439:	89 f0                	mov    %esi,%eax
8010743b:	e8 00 f9 ff ff       	call   80106d40 <mappages>
80107440:	83 c4 10             	add    $0x10,%esp
80107443:	85 c0                	test   %eax,%eax
80107445:	78 19                	js     80107460 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107447:	83 c3 10             	add    $0x10,%ebx
8010744a:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80107450:	75 d6                	jne    80107428 <setupkvm+0x28>
}
80107452:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107455:	89 f0                	mov    %esi,%eax
80107457:	5b                   	pop    %ebx
80107458:	5e                   	pop    %esi
80107459:	5d                   	pop    %ebp
8010745a:	c3                   	ret    
8010745b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010745f:	90                   	nop
      freevm(pgdir);
80107460:	83 ec 0c             	sub    $0xc,%esp
80107463:	56                   	push   %esi
      return 0;
80107464:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107466:	e8 d5 fe ff ff       	call   80107340 <freevm>
      return 0;
8010746b:	83 c4 10             	add    $0x10,%esp
}
8010746e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107471:	89 f0                	mov    %esi,%eax
80107473:	5b                   	pop    %ebx
80107474:	5e                   	pop    %esi
80107475:	5d                   	pop    %ebp
80107476:	c3                   	ret    
80107477:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010747e:	66 90                	xchg   %ax,%ax

80107480 <kvmalloc>:
{
80107480:	55                   	push   %ebp
80107481:	89 e5                	mov    %esp,%ebp
80107483:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107486:	e8 75 ff ff ff       	call   80107400 <setupkvm>
8010748b:	a3 34 b6 21 80       	mov    %eax,0x8021b634
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107490:	05 00 00 00 80       	add    $0x80000000,%eax
80107495:	0f 22 d8             	mov    %eax,%cr3
}
80107498:	c9                   	leave  
80107499:	c3                   	ret    
8010749a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801074a0 <clearpteu>:
{
801074a0:	55                   	push   %ebp
801074a1:	89 e5                	mov    %esp,%ebp
801074a3:	83 ec 08             	sub    $0x8,%esp
801074a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801074a9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801074ac:	89 c1                	mov    %eax,%ecx
801074ae:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801074b1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801074b4:	f6 c2 01             	test   $0x1,%dl
801074b7:	75 17                	jne    801074d0 <clearpteu+0x30>
    panic("clearpteu");
801074b9:	83 ec 0c             	sub    $0xc,%esp
801074bc:	68 67 91 10 80       	push   $0x80109167
801074c1:	e8 ba 8e ff ff       	call   80100380 <panic>
801074c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074cd:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801074d0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801074d3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801074d9:	25 fc 0f 00 00       	and    $0xffc,%eax
801074de:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801074e5:	85 c0                	test   %eax,%eax
801074e7:	74 d0                	je     801074b9 <clearpteu+0x19>
  *pte &= ~PTE_U;
801074e9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801074ec:	c9                   	leave  
801074ed:	c3                   	ret    
801074ee:	66 90                	xchg   %ax,%ax

801074f0 <copyuvm>:
{
801074f0:	55                   	push   %ebp
801074f1:	89 e5                	mov    %esp,%ebp
801074f3:	57                   	push   %edi
801074f4:	56                   	push   %esi
801074f5:	53                   	push   %ebx
801074f6:	83 ec 1c             	sub    $0x1c,%esp
  if((d = setupkvm()) == 0)
801074f9:	e8 02 ff ff ff       	call   80107400 <setupkvm>
801074fe:	89 c7                	mov    %eax,%edi
80107500:	85 c0                	test   %eax,%eax
80107502:	0f 84 ec 00 00 00    	je     801075f4 <copyuvm+0x104>
  for(i = 0; i < sz; i += PGSIZE){
80107508:	8b 45 0c             	mov    0xc(%ebp),%eax
8010750b:	85 c0                	test   %eax,%eax
8010750d:	0f 84 e1 00 00 00    	je     801075f4 <copyuvm+0x104>
	lcr3(V2P(pgdir));
80107513:	8b 45 08             	mov    0x8(%ebp),%eax
  for(i = 0; i < sz; i += PGSIZE){
80107516:	31 f6                	xor    %esi,%esi
	lcr3(V2P(pgdir));
80107518:	05 00 00 00 80       	add    $0x80000000,%eax
8010751d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	lcr3(V2P(d));
80107520:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
80107526:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*pde & PTE_P){
80107530:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107533:	89 f0                	mov    %esi,%eax
80107535:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107538:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010753b:	a8 01                	test   $0x1,%al
8010753d:	75 11                	jne    80107550 <copyuvm+0x60>
      panic("copyuvm: pte should exist");
8010753f:	83 ec 0c             	sub    $0xc,%esp
80107542:	68 71 91 10 80       	push   $0x80109171
80107547:	e8 34 8e ff ff       	call   80100380 <panic>
8010754c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107550:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107552:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107557:	c1 ea 0a             	shr    $0xa,%edx
8010755a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107560:	8d 8c 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%ecx
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107567:	85 c9                	test   %ecx,%ecx
80107569:	74 d4                	je     8010753f <copyuvm+0x4f>
    if(!(*pte & PTE_P))
8010756b:	8b 01                	mov    (%ecx),%eax
8010756d:	a8 01                	test   $0x1,%al
8010756f:	0f 84 c3 00 00 00    	je     80107638 <copyuvm+0x148>
    pa = PTE_ADDR(*pte);
80107575:	89 c3                	mov    %eax,%ebx
80107577:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if(flags & PTE_W){
8010757d:	a8 02                	test   $0x2,%al
8010757f:	75 7f                	jne    80107600 <copyuvm+0x110>
    flags = PTE_FLAGS(*pte);
80107581:	25 ff 0f 00 00       	and    $0xfff,%eax
80107586:	89 c2                	mov    %eax,%edx
	if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0) {
80107588:	83 ec 08             	sub    $0x8,%esp
8010758b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107590:	89 f8                	mov    %edi,%eax
80107592:	52                   	push   %edx
80107593:	89 f2                	mov    %esi,%edx
80107595:	53                   	push   %ebx
80107596:	e8 a5 f7 ff ff       	call   80106d40 <mappages>
8010759b:	83 c4 10             	add    $0x10,%esp
8010759e:	85 c0                	test   %eax,%eax
801075a0:	78 7e                	js     80107620 <copyuvm+0x130>
  acquire(&cow_lock);
801075a2:	83 ec 0c             	sub    $0xc,%esp
  uint index = PPN(pa);
801075a5:	c1 eb 0c             	shr    $0xc,%ebx
  acquire(&cow_lock);
801075a8:	68 00 b6 21 80       	push   $0x8021b600
801075ad:	e8 2e d1 ff ff       	call   801046e0 <acquire>
  if(cow_ref_counts[index] < 255)
801075b2:	0f b6 83 a0 37 11 80 	movzbl -0x7feec860(%ebx),%eax
801075b9:	83 c4 10             	add    $0x10,%esp
801075bc:	3c ff                	cmp    $0xff,%al
801075be:	74 09                	je     801075c9 <copyuvm+0xd9>
    cow_ref_counts[index]++;
801075c0:	83 c0 01             	add    $0x1,%eax
801075c3:	88 83 a0 37 11 80    	mov    %al,-0x7feec860(%ebx)
  release(&cow_lock);
801075c9:	83 ec 0c             	sub    $0xc,%esp
801075cc:	68 00 b6 21 80       	push   $0x8021b600
801075d1:	e8 aa d0 ff ff       	call   80104680 <release>
801075d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075d9:	0f 22 d8             	mov    %eax,%cr3
801075dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801075df:	0f 22 d8             	mov    %eax,%cr3
  for(i = 0; i < sz; i += PGSIZE){
801075e2:	81 c6 00 10 00 00    	add    $0x1000,%esi
801075e8:	83 c4 10             	add    $0x10,%esp
801075eb:	39 75 0c             	cmp    %esi,0xc(%ebp)
801075ee:	0f 87 3c ff ff ff    	ja     80107530 <copyuvm+0x40>
}
801075f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075f7:	89 f8                	mov    %edi,%eax
801075f9:	5b                   	pop    %ebx
801075fa:	5e                   	pop    %esi
801075fb:	5f                   	pop    %edi
801075fc:	5d                   	pop    %ebp
801075fd:	c3                   	ret    
801075fe:	66 90                	xchg   %ax,%ax
	  flags &= ~PTE_W;
80107600:	89 c2                	mov    %eax,%edx
	  *pte &= ~PTE_W;
80107602:	83 e0 fd             	and    $0xfffffffd,%eax
	  flags &= ~PTE_W;
80107605:	81 e2 fd 0f 00 00    	and    $0xffd,%edx
	  *pte |= PTE_P | PTE_U;
8010760b:	0d 05 04 00 00       	or     $0x405,%eax
80107610:	89 01                	mov    %eax,(%ecx)
	  flags |= PTE_P | PTE_U;
80107612:	81 ca 05 04 00 00    	or     $0x405,%edx
	  *pte |= PTE_P | PTE_U;
80107618:	e9 6b ff ff ff       	jmp    80107588 <copyuvm+0x98>
8010761d:	8d 76 00             	lea    0x0(%esi),%esi
  freevm(d);
80107620:	83 ec 0c             	sub    $0xc,%esp
80107623:	57                   	push   %edi
  return 0;
80107624:	31 ff                	xor    %edi,%edi
  freevm(d);
80107626:	e8 15 fd ff ff       	call   80107340 <freevm>
  return 0;
8010762b:	83 c4 10             	add    $0x10,%esp
}
8010762e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107631:	89 f8                	mov    %edi,%eax
80107633:	5b                   	pop    %ebx
80107634:	5e                   	pop    %esi
80107635:	5f                   	pop    %edi
80107636:	5d                   	pop    %ebp
80107637:	c3                   	ret    
      panic("copyuvm: page not present");
80107638:	83 ec 0c             	sub    $0xc,%esp
8010763b:	68 8b 91 10 80       	push   $0x8010918b
80107640:	e8 3b 8d ff ff       	call   80100380 <panic>
80107645:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010764c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107650 <uva2ka>:
{
80107650:	55                   	push   %ebp
80107651:	89 e5                	mov    %esp,%ebp
80107653:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107656:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107659:	89 c1                	mov    %eax,%ecx
8010765b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010765e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107661:	f6 c2 01             	test   $0x1,%dl
80107664:	0f 84 e9 0f 00 00    	je     80108653 <uva2ka.cold>
  return &pgtab[PTX(va)];
8010766a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010766d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
}
80107673:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107674:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107679:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107680:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107682:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107687:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010768a:	05 00 00 00 80       	add    $0x80000000,%eax
8010768f:	83 fa 05             	cmp    $0x5,%edx
80107692:	ba 00 00 00 00       	mov    $0x0,%edx
80107697:	0f 45 c2             	cmovne %edx,%eax
}
8010769a:	c3                   	ret    
8010769b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010769f:	90                   	nop

801076a0 <copyout>:
{
801076a0:	55                   	push   %ebp
801076a1:	89 e5                	mov    %esp,%ebp
801076a3:	57                   	push   %edi
801076a4:	56                   	push   %esi
801076a5:	53                   	push   %ebx
801076a6:	83 ec 0c             	sub    $0xc,%esp
801076a9:	8b 75 14             	mov    0x14(%ebp),%esi
801076ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801076af:	8b 55 10             	mov    0x10(%ebp),%edx
  while(len > 0){
801076b2:	85 f6                	test   %esi,%esi
801076b4:	75 51                	jne    80107707 <copyout+0x67>
801076b6:	e9 a5 00 00 00       	jmp    80107760 <copyout+0xc0>
801076bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801076bf:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
801076c0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801076c6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    if(pa0 == 0)
801076cc:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801076d2:	74 75                	je     80107749 <copyout+0xa9>
    n = PGSIZE - (va - va0);
801076d4:	89 fb                	mov    %edi,%ebx
    memmove(pa0 + (va - va0), buf, n);
801076d6:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
801076d9:	29 c3                	sub    %eax,%ebx
801076db:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801076e1:	39 f3                	cmp    %esi,%ebx
801076e3:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
801076e6:	29 f8                	sub    %edi,%eax
801076e8:	83 ec 04             	sub    $0x4,%esp
801076eb:	01 c1                	add    %eax,%ecx
801076ed:	53                   	push   %ebx
801076ee:	52                   	push   %edx
801076ef:	51                   	push   %ecx
801076f0:	e8 4b d1 ff ff       	call   80104840 <memmove>
    buf += n;
801076f5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801076f8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801076fe:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107701:	01 da                	add    %ebx,%edx
  while(len > 0){
80107703:	29 de                	sub    %ebx,%esi
80107705:	74 59                	je     80107760 <copyout+0xc0>
  if(*pde & PTE_P){
80107707:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010770a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010770c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010770e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107711:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107717:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010771a:	f6 c1 01             	test   $0x1,%cl
8010771d:	0f 84 37 0f 00 00    	je     8010865a <copyout.cold>
  return &pgtab[PTX(va)];
80107723:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107725:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010772b:	c1 eb 0c             	shr    $0xc,%ebx
8010772e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107734:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010773b:	89 d9                	mov    %ebx,%ecx
8010773d:	83 e1 05             	and    $0x5,%ecx
80107740:	83 f9 05             	cmp    $0x5,%ecx
80107743:	0f 84 77 ff ff ff    	je     801076c0 <copyout+0x20>
}
80107749:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010774c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107751:	5b                   	pop    %ebx
80107752:	5e                   	pop    %esi
80107753:	5f                   	pop    %edi
80107754:	5d                   	pop    %ebp
80107755:	c3                   	ret    
80107756:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010775d:	8d 76 00             	lea    0x0(%esi),%esi
80107760:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107763:	31 c0                	xor    %eax,%eax
}
80107765:	5b                   	pop    %ebx
80107766:	5e                   	pop    %esi
80107767:	5f                   	pop    %edi
80107768:	5d                   	pop    %ebp
80107769:	c3                   	ret    
8010776a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107770 <vasIntersect>:
int vasIntersect(uint addr1, int length1, uint addr2, int length2) {
80107770:	55                   	push   %ebp
80107771:	89 e5                	mov    %esp,%ebp
80107773:	8b 45 0c             	mov    0xc(%ebp),%eax
    if (length1 <= 0 || length2 <= 0) return 0;
80107776:	85 c0                	test   %eax,%eax
80107778:	7e 26                	jle    801077a0 <vasIntersect+0x30>
8010777a:	8b 55 14             	mov    0x14(%ebp),%edx
8010777d:	85 d2                	test   %edx,%edx
8010777f:	7e 1f                	jle    801077a0 <vasIntersect+0x30>
    if (addr1 + length1 <= addr2 || addr2 + length2 <= addr1) {
80107781:	03 45 08             	add    0x8(%ebp),%eax
        return 0;
80107784:	31 d2                	xor    %edx,%edx
    if (addr1 + length1 <= addr2 || addr2 + length2 <= addr1) {
80107786:	3b 45 10             	cmp    0x10(%ebp),%eax
80107789:	76 0e                	jbe    80107799 <vasIntersect+0x29>
8010778b:	31 d2                	xor    %edx,%edx
8010778d:	8b 45 14             	mov    0x14(%ebp),%eax
80107790:	03 45 10             	add    0x10(%ebp),%eax
80107793:	3b 45 08             	cmp    0x8(%ebp),%eax
80107796:	0f 97 c2             	seta   %dl
}
80107799:	89 d0                	mov    %edx,%eax
8010779b:	5d                   	pop    %ebp
8010779c:	c3                   	ret    
8010779d:	8d 76 00             	lea    0x0(%esi),%esi
        return 0;
801077a0:	31 d2                	xor    %edx,%edx
}
801077a2:	5d                   	pop    %ebp
801077a3:	89 d0                	mov    %edx,%eax
801077a5:	c3                   	ret    
801077a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077ad:	8d 76 00             	lea    0x0(%esi),%esi

801077b0 <updateWmap>:
			   int file_backed, int fd, int total_mmaps, int index){
801077b0:	55                   	push   %ebp
801077b1:	89 e5                	mov    %esp,%ebp
801077b3:	8b 45 24             	mov    0x24(%ebp),%eax
801077b6:	8b 55 08             	mov    0x8(%ebp),%edx
  if(index >= MAX_WMMAP_INFO) return -1;
801077b9:	83 f8 0f             	cmp    $0xf,%eax
801077bc:	77 42                	ja     80107800 <updateWmap+0x50>
  ((p->wmapInfo).addr)[index] = addr;
801077be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801077c1:	8d 04 82             	lea    (%edx,%eax,4),%eax
801077c4:	89 88 80 00 00 00    	mov    %ecx,0x80(%eax)
  ((p->wmapInfo).length)[index] = length;
801077ca:	8b 4d 10             	mov    0x10(%ebp),%ecx
801077cd:	89 88 c0 00 00 00    	mov    %ecx,0xc0(%eax)
  ((p->wmapInfo).n_loaded_pages)[index] = n_loaded_page;
801077d3:	8b 4d 14             	mov    0x14(%ebp),%ecx
801077d6:	89 88 00 01 00 00    	mov    %ecx,0x100(%eax)
  (p->wmapInfo).total_mmaps = total_mmaps;
801077dc:	8b 4d 20             	mov    0x20(%ebp),%ecx
801077df:	89 4a 7c             	mov    %ecx,0x7c(%edx)
  ((p->wmapInfoExtra).file_backed)[index] = file_backed;
801077e2:	8b 55 18             	mov    0x18(%ebp),%edx
801077e5:	89 90 40 01 00 00    	mov    %edx,0x140(%eax)
  ((p->wmapInfoExtra).fd)[index] = fd;
801077eb:	8b 55 1c             	mov    0x1c(%ebp),%edx
801077ee:	89 90 80 01 00 00    	mov    %edx,0x180(%eax)
  return 0;
801077f4:	31 c0                	xor    %eax,%eax
}
801077f6:	5d                   	pop    %ebp
801077f7:	c3                   	ret    
801077f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077ff:	90                   	nop
  if(index >= MAX_WMMAP_INFO) return -1;
80107800:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107805:	5d                   	pop    %ebp
80107806:	c3                   	ret    
80107807:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010780e:	66 90                	xchg   %ax,%ax

80107810 <printWmap>:
void printWmap(struct proc *p){
80107810:	55                   	push   %ebp
80107811:	89 e5                	mov    %esp,%ebp
80107813:	56                   	push   %esi
80107814:	8b 75 08             	mov    0x8(%ebp),%esi
80107817:	53                   	push   %ebx
  for(int i=0; i<MAX_WMMAP_INFO; i++){
80107818:	31 db                	xor    %ebx,%ebx
8010781a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	cprintf("For index %d\n", i);
80107820:	83 ec 08             	sub    $0x8,%esp
80107823:	53                   	push   %ebx
80107824:	68 a5 91 10 80       	push   $0x801091a5
80107829:	e8 72 8e ff ff       	call   801006a0 <cprintf>
	cprintf("Addr is %d, length is %d, n_loaded_pages is %d, total mmap is %d, file_backed: %d, fd: %d\n", ((p->wmapInfo).addr)[i],
8010782e:	83 c4 0c             	add    $0xc,%esp
80107831:	ff b4 9e 80 01 00 00 	push   0x180(%esi,%ebx,4)
80107838:	ff b4 9e 40 01 00 00 	push   0x140(%esi,%ebx,4)
8010783f:	ff 76 7c             	push   0x7c(%esi)
80107842:	ff b4 9e 00 01 00 00 	push   0x100(%esi,%ebx,4)
80107849:	ff b4 9e c0 00 00 00 	push   0xc0(%esi,%ebx,4)
80107850:	ff b4 9e 80 00 00 00 	push   0x80(%esi,%ebx,4)
  for(int i=0; i<MAX_WMMAP_INFO; i++){
80107857:	83 c3 01             	add    $0x1,%ebx
	cprintf("Addr is %d, length is %d, n_loaded_pages is %d, total mmap is %d, file_backed: %d, fd: %d\n", ((p->wmapInfo).addr)[i],
8010785a:	68 48 92 10 80       	push   $0x80109248
8010785f:	e8 3c 8e ff ff       	call   801006a0 <cprintf>
  for(int i=0; i<MAX_WMMAP_INFO; i++){
80107864:	83 c4 20             	add    $0x20,%esp
80107867:	83 fb 10             	cmp    $0x10,%ebx
8010786a:	75 b4                	jne    80107820 <printWmap+0x10>
}
8010786c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010786f:	5b                   	pop    %ebx
80107870:	5e                   	pop    %esi
80107871:	5d                   	pop    %ebp
80107872:	c3                   	ret    
80107873:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010787a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107880 <duplicateFd>:
{
80107880:	55                   	push   %ebp
80107881:	89 e5                	mov    %esp,%ebp
80107883:	53                   	push   %ebx
80107884:	83 ec 04             	sub    $0x4,%esp
80107887:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010788a:	e8 51 c1 ff ff       	call   801039e0 <myproc>
  if(fd < 0 || fd >= NOFILE || (f = curproc->ofile[fd]) == 0)
8010788f:	83 fb 0f             	cmp    $0xf,%ebx
80107892:	77 1c                	ja     801078b0 <duplicateFd+0x30>
80107894:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80107898:	85 d2                	test   %edx,%edx
8010789a:	74 14                	je     801078b0 <duplicateFd+0x30>
  for(newfd = 0; newfd < NOFILE; newfd++){
8010789c:	31 db                	xor    %ebx,%ebx
8010789e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[newfd] == 0){
801078a0:	8b 4c 98 28          	mov    0x28(%eax,%ebx,4),%ecx
801078a4:	85 c9                	test   %ecx,%ecx
801078a6:	74 18                	je     801078c0 <duplicateFd+0x40>
  for(newfd = 0; newfd < NOFILE; newfd++){
801078a8:	83 c3 01             	add    $0x1,%ebx
801078ab:	83 fb 10             	cmp    $0x10,%ebx
801078ae:	75 f0                	jne    801078a0 <duplicateFd+0x20>
    return -1;
801078b0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801078b5:	89 d8                	mov    %ebx,%eax
801078b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801078ba:	c9                   	leave  
801078bb:	c3                   	ret    
801078bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      filedup(f);
801078c0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[newfd] = f;
801078c3:	89 54 98 28          	mov    %edx,0x28(%eax,%ebx,4)
      filedup(f);
801078c7:	52                   	push   %edx
801078c8:	e8 e3 95 ff ff       	call   80100eb0 <filedup>
}
801078cd:	89 d8                	mov    %ebx,%eax
      return newfd;
801078cf:	83 c4 10             	add    $0x10,%esp
}
801078d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801078d5:	c9                   	leave  
801078d6:	c3                   	ret    
801078d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078de:	66 90                	xchg   %ax,%ax

801078e0 <dellocateAndUnmap>:
 int dellocateAndUnmap(struct proc *p, uint addr, int length, int i){
801078e0:	55                   	push   %ebp
801078e1:	89 e5                	mov    %esp,%ebp
801078e3:	57                   	push   %edi
801078e4:	56                   	push   %esi
801078e5:	53                   	push   %ebx
801078e6:	83 ec 1c             	sub    $0x1c,%esp
801078e9:	8b 55 08             	mov    0x8(%ebp),%edx
801078ec:	8b 45 14             	mov    0x14(%ebp),%eax
801078ef:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(((p->wmapInfo).n_loaded_pages)[i] > 0){
801078f2:	8d 04 82             	lea    (%edx,%eax,4),%eax
801078f5:	8b 88 00 01 00 00    	mov    0x100(%eax),%ecx
801078fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
801078fe:	85 c9                	test   %ecx,%ecx
80107900:	7e 5e                	jle    80107960 <dellocateAndUnmap+0x80>
    for(; a < addr+length ; a += PGSIZE){
80107902:	8b 45 10             	mov    0x10(%ebp),%eax
80107905:	01 d8                	add    %ebx,%eax
80107907:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010790a:	39 c3                	cmp    %eax,%ebx
8010790c:	72 0f                	jb     8010791d <dellocateAndUnmap+0x3d>
8010790e:	eb 50                	jmp    80107960 <dellocateAndUnmap+0x80>
		a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107910:	83 c1 01             	add    $0x1,%ecx
80107913:	89 cb                	mov    %ecx,%ebx
80107915:	c1 e3 16             	shl    $0x16,%ebx
    for(; a < addr+length ; a += PGSIZE){
80107918:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010791b:	76 43                	jbe    80107960 <dellocateAndUnmap+0x80>
  if(*pde & PTE_P){
8010791d:	8b 42 04             	mov    0x4(%edx),%eax
  pde = &pgdir[PDX(va)];
80107920:	89 d9                	mov    %ebx,%ecx
80107922:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107925:	8b 04 88             	mov    (%eax,%ecx,4),%eax
80107928:	a8 01                	test   $0x1,%al
8010792a:	74 e4                	je     80107910 <dellocateAndUnmap+0x30>
  return &pgtab[PTX(va)];
8010792c:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010792e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107933:	c1 ee 0a             	shr    $0xa,%esi
80107936:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
8010793c:	8d bc 30 00 00 00 80 	lea    -0x80000000(%eax,%esi,1),%edi
      if(!pte)
80107943:	85 ff                	test   %edi,%edi
80107945:	74 c9                	je     80107910 <dellocateAndUnmap+0x30>
      else if((*pte & PTE_P) != 0){
80107947:	8b 37                	mov    (%edi),%esi
80107949:	f7 c6 01 00 00 00    	test   $0x1,%esi
8010794f:	75 67                	jne    801079b8 <dellocateAndUnmap+0xd8>
    for(; a < addr+length ; a += PGSIZE){
80107951:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107957:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010795a:	77 c1                	ja     8010791d <dellocateAndUnmap+0x3d>
8010795c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
   if(updateWmap(p, 0, -1, 0, 0, -1, (p->wmapInfo).total_mmaps-1, i) != 0)
80107960:	8b 42 7c             	mov    0x7c(%edx),%eax
80107963:	83 e8 01             	sub    $0x1,%eax
  if(index >= MAX_WMMAP_INFO) return -1;
80107966:	83 7d 14 0f          	cmpl   $0xf,0x14(%ebp)
8010796a:	0f 87 c8 00 00 00    	ja     80107a38 <dellocateAndUnmap+0x158>
  ((p->wmapInfo).addr)[index] = addr;
80107970:	8b 7d e0             	mov    -0x20(%ebp),%edi
80107973:	c7 87 80 00 00 00 00 	movl   $0x0,0x80(%edi)
8010797a:	00 00 00 
  ((p->wmapInfo).length)[index] = length;
8010797d:	c7 87 c0 00 00 00 ff 	movl   $0xffffffff,0xc0(%edi)
80107984:	ff ff ff 
  ((p->wmapInfo).n_loaded_pages)[index] = n_loaded_page;
80107987:	c7 87 00 01 00 00 00 	movl   $0x0,0x100(%edi)
8010798e:	00 00 00 
  (p->wmapInfo).total_mmaps = total_mmaps;
80107991:	89 42 7c             	mov    %eax,0x7c(%edx)
   return SUCCESS;
80107994:	31 c0                	xor    %eax,%eax
  ((p->wmapInfoExtra).file_backed)[index] = file_backed;
80107996:	c7 87 40 01 00 00 00 	movl   $0x0,0x140(%edi)
8010799d:	00 00 00 
  ((p->wmapInfoExtra).fd)[index] = fd;
801079a0:	c7 87 80 01 00 00 ff 	movl   $0xffffffff,0x180(%edi)
801079a7:	ff ff ff 
 }
801079aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079ad:	5b                   	pop    %ebx
801079ae:	5e                   	pop    %esi
801079af:	5f                   	pop    %edi
801079b0:	5d                   	pop    %ebp
801079b1:	c3                   	ret    
801079b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if(pa == 0)
801079b8:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
801079be:	0f 84 81 00 00 00    	je     80107a45 <dellocateAndUnmap+0x165>
		if(((p->wmapInfoExtra).file_backed)[i]){
801079c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
        char *v = P2V(pa);
801079c7:	81 c6 00 00 00 80    	add    $0x80000000,%esi
		if(((p->wmapInfoExtra).file_backed)[i]){
801079cd:	8b 80 40 01 00 00    	mov    0x140(%eax),%eax
801079d3:	85 c0                	test   %eax,%eax
801079d5:	74 3b                	je     80107a12 <dellocateAndUnmap+0x132>
		  f = p->ofile[((p->wmapInfoExtra).fd)[i]];	
801079d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801079da:	8b 80 80 01 00 00    	mov    0x180(%eax),%eax
801079e0:	8b 44 82 28          	mov    0x28(%edx,%eax,4),%eax
		  if(f == 0) return FAILED;
801079e4:	85 c0                	test   %eax,%eax
801079e6:	74 50                	je     80107a38 <dellocateAndUnmap+0x158>
801079e8:	89 55 08             	mov    %edx,0x8(%ebp)
		  int offset = (a - ((p->wmapInfo).addr)[i]);
801079eb:	8b 55 e0             	mov    -0x20(%ebp),%edx
		  if(filewrite(f, v, PGSIZE) < 0) return FAILED;
801079ee:	83 ec 04             	sub    $0x4,%esp
		  int offset = (a - ((p->wmapInfo).addr)[i]);
801079f1:	89 d9                	mov    %ebx,%ecx
801079f3:	2b 8a 80 00 00 00    	sub    0x80(%edx),%ecx
		  f->off = offset;
801079f9:	89 48 14             	mov    %ecx,0x14(%eax)
		  if(filewrite(f, v, PGSIZE) < 0) return FAILED;
801079fc:	68 00 10 00 00       	push   $0x1000
80107a01:	56                   	push   %esi
80107a02:	50                   	push   %eax
80107a03:	e8 b8 96 ff ff       	call   801010c0 <filewrite>
80107a08:	83 c4 10             	add    $0x10,%esp
80107a0b:	8b 55 08             	mov    0x8(%ebp),%edx
80107a0e:	85 c0                	test   %eax,%eax
80107a10:	78 26                	js     80107a38 <dellocateAndUnmap+0x158>
        kfree(v);
80107a12:	83 ec 0c             	sub    $0xc,%esp
80107a15:	89 55 08             	mov    %edx,0x8(%ebp)
    for(; a < addr+length ; a += PGSIZE){
80107a18:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        kfree(v);
80107a1e:	56                   	push   %esi
80107a1f:	e8 ac aa ff ff       	call   801024d0 <kfree>
        *pte = 0;
80107a24:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80107a2a:	8b 55 08             	mov    0x8(%ebp),%edx
    for(; a < addr+length ; a += PGSIZE){
80107a2d:	83 c4 10             	add    $0x10,%esp
80107a30:	e9 e3 fe ff ff       	jmp    80107918 <dellocateAndUnmap+0x38>
80107a35:	8d 76 00             	lea    0x0(%esi),%esi
 }
80107a38:	8d 65 f4             	lea    -0xc(%ebp),%esp
		  if(f == 0) return FAILED;
80107a3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 }
80107a40:	5b                   	pop    %ebx
80107a41:	5e                   	pop    %esi
80107a42:	5f                   	pop    %edi
80107a43:	5d                   	pop    %ebp
80107a44:	c3                   	ret    
          panic("kfree");
80107a45:	83 ec 0c             	sub    $0xc,%esp
80107a48:	68 e9 91 10 80       	push   $0x801091e9
80107a4d:	e8 2e 89 ff ff       	call   80100380 <panic>
80107a52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107a60 <allocateAndMap>:
int allocateAndMap(struct proc *p, uint addr, int length, int i){
80107a60:	55                   	push   %ebp
80107a61:	89 e5                	mov    %esp,%ebp
80107a63:	57                   	push   %edi
80107a64:	56                   	push   %esi
80107a65:	53                   	push   %ebx
80107a66:	83 ec 1c             	sub    $0x1c,%esp
  uint endAddr = a + PGROUNDUP(length); 
80107a69:	8b 45 10             	mov    0x10(%ebp),%eax
  uint a = PGROUNDDOWN(addr);
80107a6c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  uint endAddr = a + PGROUNDUP(length); 
80107a6f:	05 ff 0f 00 00       	add    $0xfff,%eax
  uint a = PGROUNDDOWN(addr);
80107a74:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  uint endAddr = a + PGROUNDUP(length); 
80107a7a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if(endAddr >= KERNBASE)  // over the range
80107a7f:	01 d8                	add    %ebx,%eax
80107a81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107a84:	0f 88 36 01 00 00    	js     80107bc0 <allocateAndMap+0x160>
  if(DEBUG) cprintf("AllocateAndMap: Start addr: %d, end addr :%d\n", addr, endAddr);
80107a8a:	8b 35 80 37 11 80    	mov    0x80113780,%esi
80107a90:	85 f6                	test   %esi,%esi
80107a92:	0f 85 38 01 00 00    	jne    80107bd0 <allocateAndMap+0x170>
  for(; a < endAddr; a += PGSIZE){
80107a98:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80107a9b:	0f 83 4f 01 00 00    	jae    80107bf0 <allocateAndMap+0x190>
80107aa1:	8b 45 08             	mov    0x8(%ebp),%eax
80107aa4:	8b 4d 14             	mov    0x14(%ebp),%ecx
80107aa7:	8d 34 88             	lea    (%eax,%ecx,4),%esi
80107aaa:	e9 bb 00 00 00       	jmp    80107b6a <allocateAndMap+0x10a>
80107aaf:	90                   	nop
	if(((p->wmapInfoExtra).file_backed)[i]){
80107ab0:	8b 96 40 01 00 00    	mov    0x140(%esi),%edx
80107ab6:	85 d2                	test   %edx,%edx
80107ab8:	74 63                	je     80107b1d <allocateAndMap+0xbd>
	  int offset = (a - ((p->wmapInfo).addr)[i]);
80107aba:	89 d8                	mov    %ebx,%eax
80107abc:	2b 86 80 00 00 00    	sub    0x80(%esi),%eax
80107ac2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  f = myproc()->ofile[((p->wmapInfoExtra).fd)[i]];
80107ac5:	e8 16 bf ff ff       	call   801039e0 <myproc>
80107aca:	8b 96 80 01 00 00    	mov    0x180(%esi),%edx
80107ad0:	8b 54 90 28          	mov    0x28(%eax,%edx,4),%edx
	  if(f == 0){
80107ad4:	85 d2                	test   %edx,%edx
80107ad6:	0f 84 d4 00 00 00    	je     80107bb0 <allocateAndMap+0x150>
	  ilock(f->ip);
80107adc:	83 ec 0c             	sub    $0xc,%esp
80107adf:	ff 72 10             	push   0x10(%edx)
80107ae2:	89 55 dc             	mov    %edx,-0x24(%ebp)
80107ae5:	e8 a6 9c ff ff       	call   80101790 <ilock>
	  if(readi(f->ip, mem, offset, PGSIZE) == 0) return FAILED;
80107aea:	8b 55 dc             	mov    -0x24(%ebp),%edx
80107aed:	68 00 10 00 00       	push   $0x1000
80107af2:	ff 75 e0             	push   -0x20(%ebp)
80107af5:	57                   	push   %edi
80107af6:	ff 72 10             	push   0x10(%edx)
80107af9:	89 55 e0             	mov    %edx,-0x20(%ebp)
80107afc:	e8 9f 9f ff ff       	call   80101aa0 <readi>
80107b01:	83 c4 20             	add    $0x20,%esp
80107b04:	85 c0                	test   %eax,%eax
80107b06:	0f 84 b4 00 00 00    	je     80107bc0 <allocateAndMap+0x160>
	  iunlock(f->ip);
80107b0c:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107b0f:	83 ec 0c             	sub    $0xc,%esp
80107b12:	ff 72 10             	push   0x10(%edx)
80107b15:	e8 56 9d ff ff       	call   80101870 <iunlock>
80107b1a:	83 c4 10             	add    $0x10,%esp
    if(mappages(p->pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W | PTE_U | PTE_P) < 0){
80107b1d:	8b 45 08             	mov    0x8(%ebp),%eax
80107b20:	83 ec 08             	sub    $0x8,%esp
80107b23:	8d 97 00 00 00 80    	lea    -0x80000000(%edi),%edx
80107b29:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107b2e:	8b 40 04             	mov    0x4(%eax),%eax
80107b31:	6a 07                	push   $0x7
80107b33:	52                   	push   %edx
80107b34:	89 da                	mov    %ebx,%edx
80107b36:	e8 05 f2 ff ff       	call   80106d40 <mappages>
80107b3b:	83 c4 10             	add    $0x10,%esp
80107b3e:	85 c0                	test   %eax,%eax
80107b40:	0f 88 ea 00 00 00    	js     80107c30 <allocateAndMap+0x1d0>
	if(updateWmap(p, ((p->wmapInfo).addr)[i], ((p->wmapInfo).length)[i], ((p->wmapInfo).n_loaded_pages)[i]+1,
80107b46:	8b 86 00 01 00 00    	mov    0x100(%esi),%eax
80107b4c:	83 c0 01             	add    $0x1,%eax
  if(index >= MAX_WMMAP_INFO) return -1;
80107b4f:	83 7d 14 0f          	cmpl   $0xf,0x14(%ebp)
80107b53:	77 6b                	ja     80107bc0 <allocateAndMap+0x160>
  ((p->wmapInfo).n_loaded_pages)[index] = n_loaded_page;
80107b55:	89 86 00 01 00 00    	mov    %eax,0x100(%esi)
  for(; a < endAddr; a += PGSIZE){
80107b5b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107b61:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80107b64:	0f 86 86 00 00 00    	jbe    80107bf0 <allocateAndMap+0x190>
    mem = kalloc();
80107b6a:	e8 21 ab ff ff       	call   80102690 <kalloc>
80107b6f:	89 c7                	mov    %eax,%edi
	if(mem == 0){
80107b71:	85 c0                	test   %eax,%eax
80107b73:	0f 84 87 00 00 00    	je     80107c00 <allocateAndMap+0x1a0>
    memset(mem, 0, PGSIZE);
80107b79:	83 ec 04             	sub    $0x4,%esp
80107b7c:	68 00 10 00 00       	push   $0x1000
80107b81:	6a 00                	push   $0x0
80107b83:	50                   	push   %eax
80107b84:	e8 17 cc ff ff       	call   801047a0 <memset>
	if(DEBUG) cprintf("Mapping memory for addrss :%d \n", a);
80107b89:	8b 0d 80 37 11 80    	mov    0x80113780,%ecx
80107b8f:	83 c4 10             	add    $0x10,%esp
80107b92:	85 c9                	test   %ecx,%ecx
80107b94:	0f 84 16 ff ff ff    	je     80107ab0 <allocateAndMap+0x50>
80107b9a:	83 ec 08             	sub    $0x8,%esp
80107b9d:	53                   	push   %ebx
80107b9e:	68 d4 92 10 80       	push   $0x801092d4
80107ba3:	e8 f8 8a ff ff       	call   801006a0 <cprintf>
80107ba8:	83 c4 10             	add    $0x10,%esp
80107bab:	e9 00 ff ff ff       	jmp    80107ab0 <allocateAndMap+0x50>
		if(DEBUG) cprintf("AllocateAndMap: File from descriptor is null\n");
80107bb0:	a1 80 37 11 80       	mov    0x80113780,%eax
80107bb5:	85 c0                	test   %eax,%eax
80107bb7:	0f 85 8a 00 00 00    	jne    80107c47 <allocateAndMap+0x1e7>
80107bbd:	8d 76 00             	lea    0x0(%esi),%esi
	return -1;
80107bc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107bc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107bc8:	5b                   	pop    %ebx
80107bc9:	5e                   	pop    %esi
80107bca:	5f                   	pop    %edi
80107bcb:	5d                   	pop    %ebp
80107bcc:	c3                   	ret    
80107bcd:	8d 76 00             	lea    0x0(%esi),%esi
  if(DEBUG) cprintf("AllocateAndMap: Start addr: %d, end addr :%d\n", addr, endAddr);
80107bd0:	83 ec 04             	sub    $0x4,%esp
80107bd3:	50                   	push   %eax
80107bd4:	ff 75 0c             	push   0xc(%ebp)
80107bd7:	68 a4 92 10 80       	push   $0x801092a4
80107bdc:	e8 bf 8a ff ff       	call   801006a0 <cprintf>
80107be1:	83 c4 10             	add    $0x10,%esp
80107be4:	e9 af fe ff ff       	jmp    80107a98 <allocateAndMap+0x38>
80107be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80107bf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return SUCCESS;
80107bf3:	31 c0                	xor    %eax,%eax
}
80107bf5:	5b                   	pop    %ebx
80107bf6:	5e                   	pop    %esi
80107bf7:	5f                   	pop    %edi
80107bf8:	5d                   	pop    %ebp
80107bf9:	c3                   	ret    
80107bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("MMAP out of memory\n");
80107c00:	83 ec 0c             	sub    $0xc,%esp
80107c03:	68 b3 91 10 80       	push   $0x801091b3
80107c08:	e8 93 8a ff ff       	call   801006a0 <cprintf>
	  dellocateAndUnmap(p, endAddr, a, i); // deallocate
80107c0d:	ff 75 14             	push   0x14(%ebp)
80107c10:	53                   	push   %ebx
80107c11:	ff 75 e4             	push   -0x1c(%ebp)
80107c14:	ff 75 08             	push   0x8(%ebp)
80107c17:	e8 c4 fc ff ff       	call   801078e0 <dellocateAndUnmap>
	  return FAILED;
80107c1c:	83 c4 20             	add    $0x20,%esp
}
80107c1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
	  return FAILED;
80107c22:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107c27:	5b                   	pop    %ebx
80107c28:	5e                   	pop    %esi
80107c29:	5f                   	pop    %edi
80107c2a:	5d                   	pop    %ebp
80107c2b:	c3                   	ret    
80107c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	  cprintf("MMAP out of memory (2)\n");
80107c30:	83 ec 0c             	sub    $0xc,%esp
80107c33:	68 c7 91 10 80       	push   $0x801091c7
80107c38:	e8 63 8a ff ff       	call   801006a0 <cprintf>
      kfree(mem);
80107c3d:	89 3c 24             	mov    %edi,(%esp)
80107c40:	e8 8b a8 ff ff       	call   801024d0 <kfree>
80107c45:	eb c6                	jmp    80107c0d <allocateAndMap+0x1ad>
		if(DEBUG) cprintf("AllocateAndMap: File from descriptor is null\n");
80107c47:	83 ec 0c             	sub    $0xc,%esp
80107c4a:	68 f4 92 10 80       	push   $0x801092f4
80107c4f:	e8 4c 8a ff ff       	call   801006a0 <cprintf>
80107c54:	83 c4 10             	add    $0x10,%esp
		return FAILED;
80107c57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c5c:	e9 64 ff ff ff       	jmp    80107bc5 <allocateAndMap+0x165>
80107c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c6f:	90                   	nop

80107c70 <copyWmap>:
{ 
80107c70:	55                   	push   %ebp
80107c71:	89 e5                	mov    %esp,%ebp
80107c73:	57                   	push   %edi
80107c74:	56                   	push   %esi
80107c75:	53                   	push   %ebx
80107c76:	83 ec 2c             	sub    $0x2c,%esp
80107c79:	8b 7d 08             	mov    0x8(%ebp),%edi
   if(parent == 0 || child == 0) return 0;
80107c7c:	85 ff                	test   %edi,%edi
80107c7e:	0f 84 3a 01 00 00    	je     80107dbe <copyWmap+0x14e>
80107c84:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c87:	85 c0                	test   %eax,%eax
80107c89:	0f 84 2f 01 00 00    	je     80107dbe <copyWmap+0x14e>
80107c8f:	8d 87 80 00 00 00    	lea    0x80(%edi),%eax
80107c95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107c98:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c9b:	83 e8 80             	sub    $0xffffff80,%eax
80107c9e:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107ca1:	8d 87 c0 00 00 00    	lea    0xc0(%edi),%eax
80107ca7:	89 45 d8             	mov    %eax,-0x28(%ebp)
80107caa:	eb 1d                	jmp    80107cc9 <copyWmap+0x59>
80107cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     if(addr == 0 && length == -1) continue;
80107cb0:	83 f8 ff             	cmp    $0xffffffff,%eax
80107cb3:	75 25                	jne    80107cda <copyWmap+0x6a>
   for(int i=0; i < MAX_WMMAP_INFO; i++){
80107cb5:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
80107cb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107cbc:	83 45 dc 04          	addl   $0x4,-0x24(%ebp)
80107cc0:	39 45 d8             	cmp    %eax,-0x28(%ebp)
80107cc3:	0f 84 f5 00 00 00    	je     80107dbe <copyWmap+0x14e>
     addr = ((parent->wmapInfo).addr)[i];
80107cc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ccc:	8b 30                	mov    (%eax),%esi
     length = ((parent->wmapInfo).length)[i];
80107cce:	8b 40 40             	mov    0x40(%eax),%eax
     addr = ((parent->wmapInfo).addr)[i];
80107cd1:	89 75 e0             	mov    %esi,-0x20(%ebp)
80107cd4:	89 f3                	mov    %esi,%ebx
     if(addr == 0 && length == -1) continue;
80107cd6:	85 f6                	test   %esi,%esi
80107cd8:	74 d6                	je     80107cb0 <copyWmap+0x40>
     for(; a < (addr+PGROUNDUP(length)); a += PGSIZE){
80107cda:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80107cdd:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107ce3:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80107ce9:	01 ce                	add    %ecx,%esi
80107ceb:	39 f1                	cmp    %esi,%ecx
80107ced:	73 74                	jae    80107d63 <copyWmap+0xf3>
80107cef:	90                   	nop
  if(*pde & PTE_P){
80107cf0:	8b 47 04             	mov    0x4(%edi),%eax
  pde = &pgdir[PDX(va)];
80107cf3:	89 da                	mov    %ebx,%edx
80107cf5:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107cf8:	8b 04 90             	mov    (%eax,%edx,4),%eax
80107cfb:	a8 01                	test   $0x1,%al
80107cfd:	74 54                	je     80107d53 <copyWmap+0xe3>
  return &pgtab[PTX(va)];
80107cff:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107d01:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107d06:	c1 ea 0a             	shr    $0xa,%edx
80107d09:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107d0f:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
       if(!pte) continue;
80107d16:	85 c0                	test   %eax,%eax
80107d18:	74 39                	je     80107d53 <copyWmap+0xe3>
       else if((*pte & PTE_P) != 0){
80107d1a:	8b 10                	mov    (%eax),%edx
80107d1c:	f6 c2 01             	test   $0x1,%dl
80107d1f:	74 32                	je     80107d53 <copyWmap+0xe3>
         if(pa == 0) panic("copyWmap: kfree");
80107d21:	89 d1                	mov    %edx,%ecx
80107d23:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
80107d29:	0f 84 be 00 00 00    	je     80107ded <copyWmap+0x17d>
         if(mappages(child->pgdir, (char*)a, PGSIZE, pa, perm) < 0){
80107d2f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d32:	83 ec 08             	sub    $0x8,%esp
         perm = PTE_FLAGS(*pte);
80107d35:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
         if(mappages(child->pgdir, (char*)a, PGSIZE, pa, perm) < 0){
80107d3b:	8b 40 04             	mov    0x4(%eax),%eax
80107d3e:	52                   	push   %edx
80107d3f:	89 da                	mov    %ebx,%edx
80107d41:	51                   	push   %ecx
80107d42:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107d47:	e8 f4 ef ff ff       	call   80106d40 <mappages>
80107d4c:	83 c4 10             	add    $0x10,%esp
80107d4f:	85 c0                	test   %eax,%eax
80107d51:	78 7d                	js     80107dd0 <copyWmap+0x160>
     for(; a < (addr+PGROUNDUP(length)); a += PGSIZE){
80107d53:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107d59:	39 f3                	cmp    %esi,%ebx
80107d5b:	72 93                	jb     80107cf0 <copyWmap+0x80>
     if(updateWmap(child, addr, ((parent->wmapInfo).length)[i], ((parent->wmapInfo).n_loaded_pages)[i], ((parent->wmapInfoExtra).file_backed)[i],
80107d5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107d60:	8b 40 40             	mov    0x40(%eax),%eax
80107d63:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80107d66:	8b 4f 7c             	mov    0x7c(%edi),%ecx
   for(int i=0; i < MAX_WMMAP_INFO; i++){
80107d69:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
     if(updateWmap(child, addr, ((parent->wmapInfo).length)[i], ((parent->wmapInfo).n_loaded_pages)[i], ((parent->wmapInfoExtra).file_backed)[i],
80107d6d:	8b 96 c0 00 00 00    	mov    0xc0(%esi),%edx
80107d73:	8b 9e 00 01 00 00    	mov    0x100(%esi),%ebx
80107d79:	8b b6 80 00 00 00    	mov    0x80(%esi),%esi
80107d7f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  ((p->wmapInfo).addr)[index] = addr;
80107d82:	8b 55 e0             	mov    -0x20(%ebp),%edx
     if(updateWmap(child, addr, ((parent->wmapInfo).length)[i], ((parent->wmapInfo).n_loaded_pages)[i], ((parent->wmapInfoExtra).file_backed)[i],
80107d85:	89 75 d0             	mov    %esi,-0x30(%ebp)
  ((p->wmapInfo).addr)[index] = addr;
80107d88:	8b 75 dc             	mov    -0x24(%ebp),%esi
   for(int i=0; i < MAX_WMMAP_INFO; i++){
80107d8b:	83 45 dc 04          	addl   $0x4,-0x24(%ebp)
  ((p->wmapInfo).length)[index] = length;
80107d8f:	89 46 40             	mov    %eax,0x40(%esi)
  ((p->wmapInfo).n_loaded_pages)[index] = n_loaded_page;
80107d92:	8b 45 d0             	mov    -0x30(%ebp),%eax
  ((p->wmapInfo).addr)[index] = addr;
80107d95:	89 16                	mov    %edx,(%esi)
  ((p->wmapInfo).n_loaded_pages)[index] = n_loaded_page;
80107d97:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
  (p->wmapInfo).total_mmaps = total_mmaps;
80107d9d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107da0:	89 48 7c             	mov    %ecx,0x7c(%eax)
  ((p->wmapInfoExtra).file_backed)[index] = file_backed;
80107da3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  ((p->wmapInfoExtra).fd)[index] = fd;
80107da6:	89 9e 00 01 00 00    	mov    %ebx,0x100(%esi)
  ((p->wmapInfoExtra).file_backed)[index] = file_backed;
80107dac:	89 86 c0 00 00 00    	mov    %eax,0xc0(%esi)
   for(int i=0; i < MAX_WMMAP_INFO; i++){
80107db2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107db5:	39 45 d8             	cmp    %eax,-0x28(%ebp)
80107db8:	0f 85 0b ff ff ff    	jne    80107cc9 <copyWmap+0x59>
 }
80107dbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
   if(parent == 0 || child == 0) return 0;
80107dc1:	31 c0                	xor    %eax,%eax
 }
80107dc3:	5b                   	pop    %ebx
80107dc4:	5e                   	pop    %esi
80107dc5:	5f                   	pop    %edi
80107dc6:	5d                   	pop    %ebp
80107dc7:	c3                   	ret    
80107dc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107dcf:	90                   	nop
           cprintf("COPYWMAP: Failed!\n");
80107dd0:	83 ec 0c             	sub    $0xc,%esp
80107dd3:	68 ef 91 10 80       	push   $0x801091ef
80107dd8:	e8 c3 88 ff ff       	call   801006a0 <cprintf>
           return FAILED;
80107ddd:	83 c4 10             	add    $0x10,%esp
 }
80107de0:	8d 65 f4             	lea    -0xc(%ebp),%esp
           return FAILED;
80107de3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 }
80107de8:	5b                   	pop    %ebx
80107de9:	5e                   	pop    %esi
80107dea:	5f                   	pop    %edi
80107deb:	5d                   	pop    %ebp
80107dec:	c3                   	ret    
         if(pa == 0) panic("copyWmap: kfree");
80107ded:	83 ec 0c             	sub    $0xc,%esp
80107df0:	68 df 91 10 80       	push   $0x801091df
80107df5:	e8 86 85 ff ff       	call   80100380 <panic>
80107dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107e00 <set_count>:
{
80107e00:	55                   	push   %ebp
80107e01:	89 e5                	mov    %esp,%ebp
80107e03:	56                   	push   %esi
80107e04:	53                   	push   %ebx
80107e05:	8b 75 0c             	mov    0xc(%ebp),%esi
80107e08:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cow_lock);
80107e0b:	83 ec 0c             	sub    $0xc,%esp
  uint index = PPN(pa);
80107e0e:	c1 eb 0c             	shr    $0xc,%ebx
  acquire(&cow_lock);
80107e11:	68 00 b6 21 80       	push   $0x8021b600
80107e16:	e8 c5 c8 ff ff       	call   801046e0 <acquire>
  cow_ref_counts[index] = count;
80107e1b:	89 f0                	mov    %esi,%eax
  release(&cow_lock);
80107e1d:	c7 45 08 00 b6 21 80 	movl   $0x8021b600,0x8(%ebp)
80107e24:	83 c4 10             	add    $0x10,%esp
  cow_ref_counts[index] = count;
80107e27:	88 83 a0 37 11 80    	mov    %al,-0x7feec860(%ebx)
}
80107e2d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107e30:	5b                   	pop    %ebx
80107e31:	5e                   	pop    %esi
80107e32:	5d                   	pop    %ebp
  release(&cow_lock);
80107e33:	e9 48 c8 ff ff       	jmp    80104680 <release>
80107e38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e3f:	90                   	nop

80107e40 <inc_count>:
{
80107e40:	55                   	push   %ebp
80107e41:	89 e5                	mov    %esp,%ebp
80107e43:	53                   	push   %ebx
80107e44:	83 ec 10             	sub    $0x10,%esp
  uint index = PPN(pa);
80107e47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cow_lock);
80107e4a:	68 00 b6 21 80       	push   $0x8021b600
  uint index = PPN(pa);
80107e4f:	c1 eb 0c             	shr    $0xc,%ebx
  acquire(&cow_lock);
80107e52:	e8 89 c8 ff ff       	call   801046e0 <acquire>
  if(cow_ref_counts[index] < 255)
80107e57:	0f b6 83 a0 37 11 80 	movzbl -0x7feec860(%ebx),%eax
80107e5e:	83 c4 10             	add    $0x10,%esp
80107e61:	3c ff                	cmp    $0xff,%al
80107e63:	74 09                	je     80107e6e <inc_count+0x2e>
    cow_ref_counts[index]++;
80107e65:	83 c0 01             	add    $0x1,%eax
80107e68:	88 83 a0 37 11 80    	mov    %al,-0x7feec860(%ebx)
  release(&cow_lock);
80107e6e:	c7 45 08 00 b6 21 80 	movl   $0x8021b600,0x8(%ebp)
}
80107e75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107e78:	c9                   	leave  
  release(&cow_lock);
80107e79:	e9 02 c8 ff ff       	jmp    80104680 <release>
80107e7e:	66 90                	xchg   %ax,%ax

80107e80 <dec_count>:
{
80107e80:	55                   	push   %ebp
80107e81:	89 e5                	mov    %esp,%ebp
80107e83:	53                   	push   %ebx
80107e84:	83 ec 10             	sub    $0x10,%esp
  uint index = PPN(pa);
80107e87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cow_lock);
80107e8a:	68 00 b6 21 80       	push   $0x8021b600
  uint index = PPN(pa);
80107e8f:	c1 eb 0c             	shr    $0xc,%ebx
  acquire(&cow_lock);
80107e92:	e8 49 c8 ff ff       	call   801046e0 <acquire>
  if(cow_ref_counts[index] > 0)
80107e97:	0f b6 83 a0 37 11 80 	movzbl -0x7feec860(%ebx),%eax
80107e9e:	83 c4 10             	add    $0x10,%esp
80107ea1:	84 c0                	test   %al,%al
80107ea3:	74 09                	je     80107eae <dec_count+0x2e>
	cow_ref_counts[index]--;
80107ea5:	83 e8 01             	sub    $0x1,%eax
80107ea8:	88 83 a0 37 11 80    	mov    %al,-0x7feec860(%ebx)
  release(&cow_lock);
80107eae:	c7 45 08 00 b6 21 80 	movl   $0x8021b600,0x8(%ebp)
}
80107eb5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107eb8:	c9                   	leave  
  release(&cow_lock);
80107eb9:	e9 c2 c7 ff ff       	jmp    80104680 <release>
80107ebe:	66 90                	xchg   %ax,%ax

80107ec0 <get_count>:
{
80107ec0:	55                   	push   %ebp
80107ec1:	89 e5                	mov    %esp,%ebp
80107ec3:	83 ec 14             	sub    $0x14,%esp
  acquire(&cow_lock);
80107ec6:	68 00 b6 21 80       	push   $0x8021b600
80107ecb:	e8 10 c8 ff ff       	call   801046e0 <acquire>
  release(&cow_lock);
80107ed0:	c7 04 24 00 b6 21 80 	movl   $0x8021b600,(%esp)
80107ed7:	e8 a4 c7 ff ff       	call   80104680 <release>
  uint index = PPN(pa);
80107edc:	8b 45 08             	mov    0x8(%ebp),%eax
80107edf:	c1 e8 0c             	shr    $0xc,%eax
  return cow_ref_counts[index];
80107ee2:	0f b6 80 a0 37 11 80 	movzbl -0x7feec860(%eax),%eax
}
80107ee9:	c9                   	leave  
80107eea:	c3                   	ret    
80107eeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107eef:	90                   	nop

80107ef0 <handle_cow_fault>:
   return SUCCESS;
}*/

int
handle_cow_fault(struct proc *p, uint fault_addr)
{
80107ef0:	55                   	push   %ebp
80107ef1:	89 e5                	mov    %esp,%ebp
80107ef3:	57                   	push   %edi
80107ef4:	56                   	push   %esi
80107ef5:	53                   	push   %ebx
80107ef6:	83 ec 1c             	sub    $0x1c,%esp
80107ef9:	8b 75 0c             	mov    0xc(%ebp),%esi
  pte_t *pte;
  uint va = PGROUNDDOWN(fault_addr);
  if(DEBUG) cprintf("[COW_DEBUG] Fault address: 0x%x, Page-aligned: 0x%x\n", fault_addr, va);
80107efc:	8b 15 80 37 11 80    	mov    0x80113780,%edx
{
80107f02:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint va = PGROUNDDOWN(fault_addr);
80107f05:	89 f0                	mov    %esi,%eax
80107f07:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f0c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(DEBUG) cprintf("[COW_DEBUG] Fault address: 0x%x, Page-aligned: 0x%x\n", fault_addr, va);
80107f0f:	85 d2                	test   %edx,%edx
80107f11:	0f 85 99 01 00 00    	jne    801080b0 <handle_cow_fault+0x1c0>
  if(DEBUG) cprintf("[COW_DEBUG] Process size: 0x%x\n", p->sz);

  if(fault_addr >= p->sz){
80107f17:	3b 33                	cmp    (%ebx),%esi
80107f19:	0f 83 31 03 00 00    	jae    80108250 <handle_cow_fault+0x360>
  pde = &pgdir[PDX(va)];
80107f1f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  if(*pde & PTE_P){
80107f22:	8b 43 04             	mov    0x4(%ebx),%eax
  pde = &pgdir[PDX(va)];
80107f25:	89 ca                	mov    %ecx,%edx
80107f27:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107f2a:	8b 04 90             	mov    (%eax,%edx,4),%eax
  if((pte = walkpgdir(p->pgdir, (char*)va, 0)) == 0){
	if(DEBUG) cprintf("[COW_DEBUG] FAIL: Could not find PTE for address\n");
    return -1;
  }
  
  if(DEBUG) cprintf("[COW_DEBUG] PTE contents: 0x%x\n", *pte);
80107f2d:	8b 15 80 37 11 80    	mov    0x80113780,%edx
  if(*pde & PTE_P){
80107f33:	a8 01                	test   $0x1,%al
80107f35:	0f 84 25 03 00 00    	je     80108260 <handle_cow_fault+0x370>
  return &pgtab[PTX(va)];
80107f3b:	c1 e9 0a             	shr    $0xa,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107f3e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107f43:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80107f49:	8d b4 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%esi
  if((pte = walkpgdir(p->pgdir, (char*)va, 0)) == 0){
80107f50:	85 f6                	test   %esi,%esi
80107f52:	0f 84 08 03 00 00    	je     80108260 <handle_cow_fault+0x370>
  if(DEBUG) cprintf("[COW_DEBUG] PTE contents: 0x%x\n", *pte);
80107f58:	8b 06                	mov    (%esi),%eax
80107f5a:	85 d2                	test   %edx,%edx
80107f5c:	0f 85 ae 01 00 00    	jne    80108110 <handle_cow_fault+0x220>
          (*pte & PTE_P) ? 1 : 0,
          (*pte & PTE_U) ? 1 : 0,
          (*pte & PTE_W) ? 1 : 0,
          (*pte & PTE_COW) ? 1 : 0);

  if((*pte & PTE_P) == 0 || (*pte & PTE_U) == 0){
80107f62:	89 c2                	mov    %eax,%edx
80107f64:	83 e2 05             	and    $0x5,%edx
80107f67:	83 fa 05             	cmp    $0x5,%edx
80107f6a:	0f 85 e0 02 00 00    	jne    80108250 <handle_cow_fault+0x360>
    return -1;
  }
    
  // Check if this is actually a COW page
  if((*pte & PTE_COW) == 0){
	if(DEBUG) cprintf("[COW_DEBUG] FAIL: Not a COW page (PTE=0x%x)\n", *pte);
80107f70:	8b 15 80 37 11 80    	mov    0x80113780,%edx
  if((*pte & PTE_COW) == 0){
80107f76:	f6 c4 04             	test   $0x4,%ah
80107f79:	0f 84 ff 02 00 00    	je     8010827e <handle_cow_fault+0x38e>
    return -1;
  }
    
  uint pa = PTE_ADDR(*pte);
80107f7f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f84:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(DEBUG) cprintf("[COW_DEBUG] Physical address: 0x%x\n", pa);
80107f87:	85 d2                	test   %edx,%edx
80107f89:	0f 85 61 02 00 00    	jne    801081f0 <handle_cow_fault+0x300>
  acquire(&cow_lock);
80107f8f:	83 ec 0c             	sub    $0xc,%esp
80107f92:	68 00 b6 21 80       	push   $0x8021b600
80107f97:	e8 44 c7 ff ff       	call   801046e0 <acquire>
  uint index = PPN(pa);
80107f9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  release(&cow_lock);
80107f9f:	c7 04 24 00 b6 21 80 	movl   $0x8021b600,(%esp)
  uint index = PPN(pa);
80107fa6:	c1 e8 0c             	shr    $0xc,%eax
80107fa9:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107fac:	89 c7                	mov    %eax,%edi
  release(&cow_lock);
80107fae:	e8 cd c6 ff ff       	call   80104680 <release>
  unsigned char ref_count = get_count(pa);
  if(DEBUG) cprintf("[COW_DEBUG] Reference count for page: %d\n", ref_count);
80107fb3:	8b 0d 80 37 11 80    	mov    0x80113780,%ecx
  return cow_ref_counts[index];
80107fb9:	0f b6 87 a0 37 11 80 	movzbl -0x7feec860(%edi),%eax
  if(DEBUG) cprintf("[COW_DEBUG] Reference count for page: %d\n", ref_count);
80107fc0:	83 c4 10             	add    $0x10,%esp
80107fc3:	85 c9                	test   %ecx,%ecx
80107fc5:	0f 85 d5 01 00 00    	jne    801081a0 <handle_cow_fault+0x2b0>

  if(ref_count < 1){
80107fcb:	84 c0                	test   %al,%al
80107fcd:	0f 84 7d 02 00 00    	je     80108250 <handle_cow_fault+0x360>
	if(DEBUG) cprintf("[COW_DEBUG] FAIL: Invalid reference count of 0\n");
	return -1;
  } 
 
  // If reference count is 1, just make it writable
  if(ref_count == 1) {
80107fd3:	3c 01                	cmp    $0x1,%al
80107fd5:	0f 84 49 02 00 00    	je     80108224 <handle_cow_fault+0x334>
    return 0;
  }
  
  if(DEBUG) cprintf("[COW_DEBUG] Multiple references (%d), creating new page\n", ref_count);
  // Otherwise, need to allocate new page and copy
  char *mem = kalloc();
80107fdb:	e8 b0 a6 ff ff       	call   80102690 <kalloc>
80107fe0:	89 c7                	mov    %eax,%edi
  if(mem == 0){
80107fe2:	85 c0                	test   %eax,%eax
80107fe4:	0f 84 b3 02 00 00    	je     8010829d <handle_cow_fault+0x3ad>
	if(DEBUG) cprintf("MEM IS ZERO!\n");
	return -1;
  }

  memmove(mem, (char*)P2V(pa), PGSIZE);
80107fea:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107fed:	83 ec 04             	sub    $0x4,%esp
80107ff0:	68 00 10 00 00       	push   $0x1000
80107ff5:	05 00 00 00 80       	add    $0x80000000,%eax
80107ffa:	50                   	push   %eax
80107ffb:	57                   	push   %edi
80107ffc:	e8 3f c8 ff ff       	call   80104840 <memmove>
  acquire(&cow_lock);
80108001:	c7 04 24 00 b6 21 80 	movl   $0x8021b600,(%esp)
80108008:	e8 d3 c6 ff ff       	call   801046e0 <acquire>
  if(cow_ref_counts[index] > 0)
8010800d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80108010:	83 c4 10             	add    $0x10,%esp
80108013:	0f b6 81 a0 37 11 80 	movzbl -0x7feec860(%ecx),%eax
8010801a:	84 c0                	test   %al,%al
8010801c:	74 09                	je     80108027 <handle_cow_fault+0x137>
	cow_ref_counts[index]--;
8010801e:	83 e8 01             	sub    $0x1,%eax
80108021:	88 81 a0 37 11 80    	mov    %al,-0x7feec860(%ecx)
  release(&cow_lock);
80108027:	83 ec 0c             	sub    $0xc,%esp
8010802a:	68 00 b6 21 80       	push   $0x8021b600
8010802f:	e8 4c c6 ff ff       	call   80104680 <release>
  dec_count(pa);
  // Map the new page with write permission
  uint flags = (PTE_FLAGS(*pte) | PTE_W) & ~PTE_COW;
80108034:	8b 16                	mov    (%esi),%edx
  *pte = 0; // unmap

  if(mappages(p->pgdir, (char*)PGROUNDDOWN(va), PGSIZE, V2P(mem), flags) != 0) {
80108036:	83 c4 08             	add    $0x8,%esp
  *pte = 0; // unmap
80108039:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if(mappages(p->pgdir, (char*)PGROUNDDOWN(va), PGSIZE, V2P(mem), flags) != 0) {
8010803f:	8d b7 00 00 00 80    	lea    -0x80000000(%edi),%esi
80108045:	8b 43 04             	mov    0x4(%ebx),%eax
80108048:	b9 00 10 00 00       	mov    $0x1000,%ecx
  uint flags = (PTE_FLAGS(*pte) | PTE_W) & ~PTE_COW;
8010804d:	81 e2 fd 0b 00 00    	and    $0xbfd,%edx
80108053:	83 ca 02             	or     $0x2,%edx
  if(mappages(p->pgdir, (char*)PGROUNDDOWN(va), PGSIZE, V2P(mem), flags) != 0) {
80108056:	52                   	push   %edx
80108057:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010805a:	56                   	push   %esi
8010805b:	e8 e0 ec ff ff       	call   80106d40 <mappages>
80108060:	83 c4 10             	add    $0x10,%esp
80108063:	85 c0                	test   %eax,%eax
80108065:	0f 85 d8 01 00 00    	jne    80108243 <handle_cow_fault+0x353>
  acquire(&cow_lock);
8010806b:	83 ec 0c             	sub    $0xc,%esp
  uint index = PPN(pa);
8010806e:	c1 ee 0c             	shr    $0xc,%esi
80108071:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  acquire(&cow_lock);
80108074:	68 00 b6 21 80       	push   $0x8021b600
80108079:	e8 62 c6 ff ff       	call   801046e0 <acquire>
  release(&cow_lock);
8010807e:	c7 04 24 00 b6 21 80 	movl   $0x8021b600,(%esp)
  cow_ref_counts[index] = count;
80108085:	c6 86 a0 37 11 80 01 	movb   $0x1,-0x7feec860(%esi)
  release(&cow_lock);
8010808c:	e8 ef c5 ff ff       	call   80104680 <release>
  }
  
  // Set reference count of new page to 1
  set_count(V2P(mem), 1);
  // Flush TLB
  lcr3(V2P(p->pgdir));
80108091:	8b 53 04             	mov    0x4(%ebx),%edx
80108094:	81 c2 00 00 00 80    	add    $0x80000000,%edx
8010809a:	0f 22 da             	mov    %edx,%cr3
  
  return 0;
8010809d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801080a0:	83 c4 10             	add    $0x10,%esp
}
801080a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801080a6:	5b                   	pop    %ebx
801080a7:	5e                   	pop    %esi
801080a8:	5f                   	pop    %edi
801080a9:	5d                   	pop    %ebp
801080aa:	c3                   	ret    
801080ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801080af:	90                   	nop
  if(DEBUG) cprintf("[COW_DEBUG] Fault address: 0x%x, Page-aligned: 0x%x\n", fault_addr, va);
801080b0:	83 ec 04             	sub    $0x4,%esp
801080b3:	50                   	push   %eax
801080b4:	56                   	push   %esi
801080b5:	68 24 93 10 80       	push   $0x80109324
801080ba:	e8 e1 85 ff ff       	call   801006a0 <cprintf>
  if(DEBUG) cprintf("[COW_DEBUG] Process size: 0x%x\n", p->sz);
801080bf:	a1 80 37 11 80       	mov    0x80113780,%eax
801080c4:	83 c4 10             	add    $0x10,%esp
801080c7:	85 c0                	test   %eax,%eax
801080c9:	0f 84 48 fe ff ff    	je     80107f17 <handle_cow_fault+0x27>
801080cf:	83 ec 08             	sub    $0x8,%esp
801080d2:	ff 33                	push   (%ebx)
801080d4:	68 5c 93 10 80       	push   $0x8010935c
801080d9:	e8 c2 85 ff ff       	call   801006a0 <cprintf>
  if(fault_addr >= p->sz){
801080de:	83 c4 10             	add    $0x10,%esp
801080e1:	39 33                	cmp    %esi,(%ebx)
801080e3:	0f 87 36 fe ff ff    	ja     80107f1f <handle_cow_fault+0x2f>
	if(DEBUG) cprintf("[COW_DEBUG] FAIL: Fault address beyond process size\n");
801080e9:	a1 80 37 11 80       	mov    0x80113780,%eax
801080ee:	85 c0                	test   %eax,%eax
801080f0:	0f 84 5a 01 00 00    	je     80108250 <handle_cow_fault+0x360>
801080f6:	83 ec 0c             	sub    $0xc,%esp
801080f9:	68 7c 93 10 80       	push   $0x8010937c
801080fe:	e8 9d 85 ff ff       	call   801006a0 <cprintf>
80108103:	83 c4 10             	add    $0x10,%esp
	return -1;
80108106:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010810b:	eb 96                	jmp    801080a3 <handle_cow_fault+0x1b3>
8010810d:	8d 76 00             	lea    0x0(%esi),%esi
  if(DEBUG) cprintf("[COW_DEBUG] PTE contents: 0x%x\n", *pte);
80108110:	83 ec 08             	sub    $0x8,%esp
80108113:	50                   	push   %eax
80108114:	68 e8 93 10 80       	push   $0x801093e8
80108119:	e8 82 85 ff ff       	call   801006a0 <cprintf>
  if(DEBUG) cprintf("[COW_DEBUG] PTE flags: Present=%d, User=%d, Writable=%d, COW=%d\n", 
8010811e:	8b 3d 80 37 11 80    	mov    0x80113780,%edi
          (*pte & PTE_COW) ? 1 : 0);
80108124:	8b 06                	mov    (%esi),%eax
  if(DEBUG) cprintf("[COW_DEBUG] PTE flags: Present=%d, User=%d, Writable=%d, COW=%d\n", 
80108126:	83 c4 10             	add    $0x10,%esp
80108129:	85 ff                	test   %edi,%edi
8010812b:	0f 84 31 fe ff ff    	je     80107f62 <handle_cow_fault+0x72>
          (*pte & PTE_COW) ? 1 : 0);
80108131:	89 c2                	mov    %eax,%edx
  if(DEBUG) cprintf("[COW_DEBUG] PTE flags: Present=%d, User=%d, Writable=%d, COW=%d\n", 
80108133:	83 ec 0c             	sub    $0xc,%esp
          (*pte & PTE_COW) ? 1 : 0);
80108136:	c1 ea 0a             	shr    $0xa,%edx
  if(DEBUG) cprintf("[COW_DEBUG] PTE flags: Present=%d, User=%d, Writable=%d, COW=%d\n", 
80108139:	83 e2 01             	and    $0x1,%edx
8010813c:	52                   	push   %edx
          (*pte & PTE_W) ? 1 : 0,
8010813d:	89 c2                	mov    %eax,%edx
8010813f:	d1 ea                	shr    %edx
  if(DEBUG) cprintf("[COW_DEBUG] PTE flags: Present=%d, User=%d, Writable=%d, COW=%d\n", 
80108141:	83 e2 01             	and    $0x1,%edx
80108144:	52                   	push   %edx
          (*pte & PTE_U) ? 1 : 0,
80108145:	89 c2                	mov    %eax,%edx
  if(DEBUG) cprintf("[COW_DEBUG] PTE flags: Present=%d, User=%d, Writable=%d, COW=%d\n", 
80108147:	83 e0 01             	and    $0x1,%eax
          (*pte & PTE_U) ? 1 : 0,
8010814a:	c1 ea 02             	shr    $0x2,%edx
  if(DEBUG) cprintf("[COW_DEBUG] PTE flags: Present=%d, User=%d, Writable=%d, COW=%d\n", 
8010814d:	83 e2 01             	and    $0x1,%edx
80108150:	52                   	push   %edx
80108151:	50                   	push   %eax
80108152:	68 08 94 10 80       	push   $0x80109408
80108157:	e8 44 85 ff ff       	call   801006a0 <cprintf>
  if((*pte & PTE_P) == 0 || (*pte & PTE_U) == 0){
8010815c:	8b 06                	mov    (%esi),%eax
8010815e:	83 c4 20             	add    $0x20,%esp
80108161:	89 c2                	mov    %eax,%edx
80108163:	83 e2 05             	and    $0x5,%edx
80108166:	83 fa 05             	cmp    $0x5,%edx
80108169:	0f 84 01 fe ff ff    	je     80107f70 <handle_cow_fault+0x80>
	if(DEBUG) cprintf("[COW_DEBUG] FAIL: Page not present or not user-accessible\n");
8010816f:	8b 1d 80 37 11 80    	mov    0x80113780,%ebx
80108175:	85 db                	test   %ebx,%ebx
80108177:	0f 84 d3 00 00 00    	je     80108250 <handle_cow_fault+0x360>
8010817d:	83 ec 0c             	sub    $0xc,%esp
80108180:	68 4c 94 10 80       	push   $0x8010944c
80108185:	e8 16 85 ff ff       	call   801006a0 <cprintf>
8010818a:	83 c4 10             	add    $0x10,%esp
    return -1;
8010818d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108192:	e9 0c ff ff ff       	jmp    801080a3 <handle_cow_fault+0x1b3>
80108197:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010819e:	66 90                	xchg   %ax,%ax
  if(DEBUG) cprintf("[COW_DEBUG] Reference count for page: %d\n", ref_count);
801081a0:	83 ec 08             	sub    $0x8,%esp
801081a3:	0f b6 f8             	movzbl %al,%edi
801081a6:	88 45 db             	mov    %al,-0x25(%ebp)
801081a9:	57                   	push   %edi
801081aa:	68 dc 94 10 80       	push   $0x801094dc
801081af:	e8 ec 84 ff ff       	call   801006a0 <cprintf>
  if(ref_count < 1){
801081b4:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
801081b8:	83 c4 10             	add    $0x10,%esp
801081bb:	84 c0                	test   %al,%al
801081bd:	0f 84 fd 00 00 00    	je     801082c0 <handle_cow_fault+0x3d0>
	if(DEBUG) cprintf("[COW_DEBUG] FAIL: Invalid reference count of 0\n");
801081c3:	8b 15 80 37 11 80    	mov    0x80113780,%edx
  if(ref_count == 1) {
801081c9:	3c 01                	cmp    $0x1,%al
801081cb:	74 43                	je     80108210 <handle_cow_fault+0x320>
  if(DEBUG) cprintf("[COW_DEBUG] Multiple references (%d), creating new page\n", ref_count);
801081cd:	85 d2                	test   %edx,%edx
801081cf:	0f 84 06 fe ff ff    	je     80107fdb <handle_cow_fault+0xeb>
801081d5:	83 ec 08             	sub    $0x8,%esp
801081d8:	57                   	push   %edi
801081d9:	68 70 95 10 80       	push   $0x80109570
801081de:	e8 bd 84 ff ff       	call   801006a0 <cprintf>
801081e3:	83 c4 10             	add    $0x10,%esp
801081e6:	e9 f0 fd ff ff       	jmp    80107fdb <handle_cow_fault+0xeb>
801081eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801081ef:	90                   	nop
  if(DEBUG) cprintf("[COW_DEBUG] Physical address: 0x%x\n", pa);
801081f0:	83 ec 08             	sub    $0x8,%esp
801081f3:	50                   	push   %eax
801081f4:	68 b8 94 10 80       	push   $0x801094b8
801081f9:	e8 a2 84 ff ff       	call   801006a0 <cprintf>
801081fe:	83 c4 10             	add    $0x10,%esp
80108201:	e9 89 fd ff ff       	jmp    80107f8f <handle_cow_fault+0x9f>
80108206:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010820d:	8d 76 00             	lea    0x0(%esi),%esi
	if(DEBUG) cprintf("[COW_DEBUG] Single reference, converting to writable\n");
80108210:	85 d2                	test   %edx,%edx
80108212:	74 10                	je     80108224 <handle_cow_fault+0x334>
80108214:	83 ec 0c             	sub    $0xc,%esp
80108217:	68 38 95 10 80       	push   $0x80109538
8010821c:	e8 7f 84 ff ff       	call   801006a0 <cprintf>
80108221:	83 c4 10             	add    $0x10,%esp
    *pte &= ~PTE_COW;
80108224:	8b 06                	mov    (%esi),%eax
80108226:	80 e4 fb             	and    $0xfb,%ah
80108229:	83 c8 02             	or     $0x2,%eax
8010822c:	89 06                	mov    %eax,(%esi)
    lcr3(V2P(p->pgdir));  // Flush TLB
8010822e:	8b 43 04             	mov    0x4(%ebx),%eax
80108231:	05 00 00 00 80       	add    $0x80000000,%eax
80108236:	0f 22 d8             	mov    %eax,%cr3
}
80108239:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
8010823c:	31 c0                	xor    %eax,%eax
}
8010823e:	5b                   	pop    %ebx
8010823f:	5e                   	pop    %esi
80108240:	5f                   	pop    %edi
80108241:	5d                   	pop    %ebp
80108242:	c3                   	ret    
    kfree(mem);
80108243:	83 ec 0c             	sub    $0xc,%esp
80108246:	57                   	push   %edi
80108247:	e8 84 a2 ff ff       	call   801024d0 <kfree>
    return -1;
8010824c:	83 c4 10             	add    $0x10,%esp
8010824f:	90                   	nop
80108250:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108255:	e9 49 fe ff ff       	jmp    801080a3 <handle_cow_fault+0x1b3>
8010825a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	if(DEBUG) cprintf("[COW_DEBUG] FAIL: Could not find PTE for address\n");
80108260:	85 d2                	test   %edx,%edx
80108262:	74 ec                	je     80108250 <handle_cow_fault+0x360>
80108264:	83 ec 0c             	sub    $0xc,%esp
80108267:	68 b4 93 10 80       	push   $0x801093b4
8010826c:	e8 2f 84 ff ff       	call   801006a0 <cprintf>
80108271:	83 c4 10             	add    $0x10,%esp
    return -1;
80108274:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108279:	e9 25 fe ff ff       	jmp    801080a3 <handle_cow_fault+0x1b3>
	if(DEBUG) cprintf("[COW_DEBUG] FAIL: Not a COW page (PTE=0x%x)\n", *pte);
8010827e:	85 d2                	test   %edx,%edx
80108280:	74 ce                	je     80108250 <handle_cow_fault+0x360>
80108282:	83 ec 08             	sub    $0x8,%esp
80108285:	50                   	push   %eax
80108286:	68 88 94 10 80       	push   $0x80109488
8010828b:	e8 10 84 ff ff       	call   801006a0 <cprintf>
80108290:	83 c4 10             	add    $0x10,%esp
    return -1;
80108293:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108298:	e9 06 fe ff ff       	jmp    801080a3 <handle_cow_fault+0x1b3>
	if(DEBUG) cprintf("MEM IS ZERO!\n");
8010829d:	a1 80 37 11 80       	mov    0x80113780,%eax
801082a2:	85 c0                	test   %eax,%eax
801082a4:	74 aa                	je     80108250 <handle_cow_fault+0x360>
801082a6:	83 ec 0c             	sub    $0xc,%esp
801082a9:	68 02 92 10 80       	push   $0x80109202
801082ae:	e8 ed 83 ff ff       	call   801006a0 <cprintf>
801082b3:	83 c4 10             	add    $0x10,%esp
	return -1;
801082b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801082bb:	e9 e3 fd ff ff       	jmp    801080a3 <handle_cow_fault+0x1b3>
	if(DEBUG) cprintf("[COW_DEBUG] FAIL: Invalid reference count of 0\n");
801082c0:	8b 15 80 37 11 80    	mov    0x80113780,%edx
801082c6:	85 d2                	test   %edx,%edx
801082c8:	74 86                	je     80108250 <handle_cow_fault+0x360>
801082ca:	83 ec 0c             	sub    $0xc,%esp
801082cd:	68 08 95 10 80       	push   $0x80109508
801082d2:	e8 c9 83 ff ff       	call   801006a0 <cprintf>
801082d7:	83 c4 10             	add    $0x10,%esp
	return -1;
801082da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801082df:	e9 bf fd ff ff       	jmp    801080a3 <handle_cow_fault+0x1b3>
801082e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801082eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801082ef:	90                   	nop

801082f0 <wmap>:
Actual syscall functions are below
*/

uint
wmap(uint addr, int length, int flags, int fd)
{
801082f0:	55                   	push   %ebp
	1. MAP_SHARED is always set to true, always write back
	2. MAP_FIXED is always set to true, always only find virtual address EXACTLY AT addr
  */

  int fileBacked = 1;
  if(flags & MAP_ANONYMOUS) fileBacked = 0; // ignore fd
801082f1:	31 c0                	xor    %eax,%eax
{
801082f3:	89 e5                	mov    %esp,%ebp
801082f5:	57                   	push   %edi
801082f6:	56                   	push   %esi
801082f7:	53                   	push   %ebx
801082f8:	83 ec 2c             	sub    $0x2c,%esp
  if(flags & MAP_ANONYMOUS) fileBacked = 0; // ignore fd
801082fb:	f6 45 10 04          	testb  $0x4,0x10(%ebp)
  if(DEBUG) cprintf("WMAP: fbacked: %d\n", fileBacked);
801082ff:	8b 15 80 37 11 80    	mov    0x80113780,%edx
  if(flags & MAP_ANONYMOUS) fileBacked = 0; // ignore fd
80108305:	0f 94 c0             	sete   %al
{
80108308:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010830b:	8b 75 14             	mov    0x14(%ebp),%esi
  if(flags & MAP_ANONYMOUS) fileBacked = 0; // ignore fd
8010830e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  if(DEBUG) cprintf("WMAP: fbacked: %d\n", fileBacked);
80108311:	85 d2                	test   %edx,%edx
80108313:	0f 85 7f 01 00 00    	jne    80108498 <wmap+0x1a8>
  // now we retrive our process and check if the process have already used the virtual address range
  struct proc *p = myproc();
80108319:	e8 c2 b6 ff ff       	call   801039e0 <myproc>
  int emptySpot = -1;

  // duplicate fd
  int fdToStore = -1;
8010831e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  struct proc *p = myproc();
80108325:	89 c3                	mov    %eax,%ebx
  if(fd >= 0) fdToStore = duplicateFd(fd);
80108327:	85 f6                	test   %esi,%esi
80108329:	0f 89 29 01 00 00    	jns    80108458 <wmap+0x168>
  if(fdToStore < 0){
	if(DEBUG) cprintf("WMAP: Duplicating file descriptor failed;\n");
8010832f:	a1 80 37 11 80       	mov    0x80113780,%eax
80108334:	85 c0                	test   %eax,%eax
80108336:	0f 85 74 01 00 00    	jne    801084b0 <wmap+0x1c0>
    if (addr1 + length1 <= addr2 || addr2 + length2 <= addr1) {
8010833c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  // loop through the process wmap to check if the given addr and length are valid
  if(DEBUG) cprintf("WMAP: Made it after first checks\n");
  // loop through the process wmap to check if the given addr and length are valid
  for(int i = 0; i < MAX_WMMAP_INFO; i++){
	// check if it is full
    if((p->wmapInfo).total_mmaps == MAX_WMMAP_INFO) return FAILED; // null pointer
8010833f:	8b 73 7c             	mov    0x7c(%ebx),%esi
80108342:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
80108349:	31 c0                	xor    %eax,%eax
    if (addr1 + length1 <= addr2 || addr2 + length2 <= addr1) {
8010834b:	01 f9                	add    %edi,%ecx
8010834d:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80108350:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    if((p->wmapInfo).total_mmaps == MAX_WMMAP_INFO) return FAILED; // null pointer
80108353:	83 7d e4 10          	cmpl   $0x10,-0x1c(%ebp)
80108357:	74 3a                	je     80108393 <wmap+0xa3>

    // continue if not allocated
    if(((p->wmapInfo).addr)[i] == 0 && ((p->wmapInfo).length)[i] == -1){
80108359:	8b 94 83 80 00 00 00 	mov    0x80(%ebx,%eax,4),%edx
80108360:	8b 8c 83 c0 00 00 00 	mov    0xc0(%ebx,%eax,4),%ecx
80108367:	85 d2                	test   %edx,%edx
80108369:	75 05                	jne    80108370 <wmap+0x80>
8010836b:	83 f9 ff             	cmp    $0xffffffff,%ecx
8010836e:	74 30                	je     801083a0 <wmap+0xb0>
    if (length1 <= 0 || length2 <= 0) return 0;
80108370:	85 ff                	test   %edi,%edi
80108372:	7e 3c                	jle    801083b0 <wmap+0xc0>
80108374:	85 c9                	test   %ecx,%ecx
80108376:	7e 38                	jle    801083b0 <wmap+0xc0>
    if (addr1 + length1 <= addr2 || addr2 + length2 <= addr1) {
80108378:	3b 55 e0             	cmp    -0x20(%ebp),%edx
8010837b:	73 33                	jae    801083b0 <wmap+0xc0>
8010837d:	8d 34 11             	lea    (%ecx,%edx,1),%esi
80108380:	39 75 08             	cmp    %esi,0x8(%ebp)
80108383:	73 2b                	jae    801083b0 <wmap+0xc0>
	  continue;
    }

	// check if given address is free
    if(vasIntersect(addr, length, ((p->wmapInfo).addr)[i], ((p->wmapInfo).length)[i])){
	  if(DEBUG) cprintf("WMAP: Address intersects %d %d %d %d\n", addr, length, ((p->wmapInfo).addr)[i], ((p->wmapInfo).length)[i]);
80108385:	8b 1d 80 37 11 80    	mov    0x80113780,%ebx
8010838b:	85 db                	test   %ebx,%ebx
8010838d:	0f 85 a5 00 00 00    	jne    80108438 <wmap+0x148>
	  return FAILED;
80108393:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(updateWmap(p, addr, length, 0, fileBacked, fdToStore, (p->wmapInfo).total_mmaps+1, emptySpot) != 0) return FAILED;

  if(DEBUG) printWmap(p);

  return addr;
}
80108398:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010839b:	5b                   	pop    %ebx
8010839c:	5e                   	pop    %esi
8010839d:	5f                   	pop    %edi
8010839e:	5d                   	pop    %ebp
8010839f:	c3                   	ret    
	  if(emptySpot == -1) emptySpot = i;
801083a0:	8b 55 dc             	mov    -0x24(%ebp),%edx
801083a3:	83 fa ff             	cmp    $0xffffffff,%edx
801083a6:	0f 44 d0             	cmove  %eax,%edx
801083a9:	89 55 dc             	mov    %edx,-0x24(%ebp)
801083ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(int i = 0; i < MAX_WMMAP_INFO; i++){
801083b0:	83 c0 01             	add    $0x1,%eax
801083b3:	83 f8 10             	cmp    $0x10,%eax
801083b6:	75 9b                	jne    80108353 <wmap+0x63>
  if(emptySpot == -1) return FAILED; // no empty spot found
801083b8:	83 7d dc ff          	cmpl   $0xffffffff,-0x24(%ebp)
801083bc:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801083bf:	74 d2                	je     80108393 <wmap+0xa3>
  if(DEBUG) cprintf("WMAP: Updating wmap at index %d with addr %d, file_backed %d, fd %d\n", emptySpot, addr, fileBacked, fdToStore);
801083c1:	8b 0d 80 37 11 80    	mov    0x80113780,%ecx
801083c7:	85 c9                	test   %ecx,%ecx
801083c9:	0f 85 f9 00 00 00    	jne    801084c8 <wmap+0x1d8>
  if(updateWmap(p, addr, length, 0, fileBacked, fdToStore, (p->wmapInfo).total_mmaps+1, emptySpot) != 0) return FAILED;
801083cf:	83 c6 01             	add    $0x1,%esi
  if(index >= MAX_WMMAP_INFO) return -1;
801083d2:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
801083d6:	7f bb                	jg     80108393 <wmap+0xa3>
  ((p->wmapInfo).addr)[index] = addr;
801083d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
801083db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if(DEBUG) printWmap(p);
801083de:	8b 15 80 37 11 80    	mov    0x80113780,%edx
801083e4:	8d 04 83             	lea    (%ebx,%eax,4),%eax
  ((p->wmapInfo).length)[index] = length;
801083e7:	89 b8 c0 00 00 00    	mov    %edi,0xc0(%eax)
  ((p->wmapInfoExtra).file_backed)[index] = file_backed;
801083ed:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  ((p->wmapInfo).addr)[index] = addr;
801083f0:	89 88 80 00 00 00    	mov    %ecx,0x80(%eax)
  ((p->wmapInfo).n_loaded_pages)[index] = n_loaded_page;
801083f6:	c7 80 00 01 00 00 00 	movl   $0x0,0x100(%eax)
801083fd:	00 00 00 
  (p->wmapInfo).total_mmaps = total_mmaps;
80108400:	89 73 7c             	mov    %esi,0x7c(%ebx)
  ((p->wmapInfoExtra).file_backed)[index] = file_backed;
80108403:	89 b8 40 01 00 00    	mov    %edi,0x140(%eax)
  ((p->wmapInfoExtra).fd)[index] = fd;
80108409:	8b 7d d8             	mov    -0x28(%ebp),%edi
8010840c:	89 b8 80 01 00 00    	mov    %edi,0x180(%eax)
  if(DEBUG) printWmap(p);
80108412:	89 c8                	mov    %ecx,%eax
80108414:	85 d2                	test   %edx,%edx
80108416:	0f 84 7c ff ff ff    	je     80108398 <wmap+0xa8>
8010841c:	83 ec 0c             	sub    $0xc,%esp
8010841f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80108422:	53                   	push   %ebx
80108423:	e8 e8 f3 ff ff       	call   80107810 <printWmap>
80108428:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010842b:	83 c4 10             	add    $0x10,%esp
8010842e:	e9 65 ff ff ff       	jmp    80108398 <wmap+0xa8>
80108433:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108437:	90                   	nop
	  if(DEBUG) cprintf("WMAP: Address intersects %d %d %d %d\n", addr, length, ((p->wmapInfo).addr)[i], ((p->wmapInfo).length)[i]);
80108438:	83 ec 0c             	sub    $0xc,%esp
8010843b:	51                   	push   %ecx
8010843c:	52                   	push   %edx
8010843d:	57                   	push   %edi
8010843e:	ff 75 08             	push   0x8(%ebp)
80108441:	68 fc 95 10 80       	push   $0x801095fc
80108446:	e8 55 82 ff ff       	call   801006a0 <cprintf>
8010844b:	83 c4 20             	add    $0x20,%esp
8010844e:	e9 40 ff ff ff       	jmp    80108393 <wmap+0xa3>
80108453:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108457:	90                   	nop
  if(fd >= 0) fdToStore = duplicateFd(fd);
80108458:	83 ec 0c             	sub    $0xc,%esp
8010845b:	56                   	push   %esi
8010845c:	e8 1f f4 ff ff       	call   80107880 <duplicateFd>
  if(fdToStore < 0){
80108461:	83 c4 10             	add    $0x10,%esp
  if(fd >= 0) fdToStore = duplicateFd(fd);
80108464:	89 45 d8             	mov    %eax,-0x28(%ebp)
  if(fdToStore < 0){
80108467:	85 c0                	test   %eax,%eax
80108469:	0f 88 c0 fe ff ff    	js     8010832f <wmap+0x3f>
  if(DEBUG) cprintf("WMAP: Made it after first checks\n");
8010846f:	8b 35 80 37 11 80    	mov    0x80113780,%esi
80108475:	85 f6                	test   %esi,%esi
80108477:	0f 84 bf fe ff ff    	je     8010833c <wmap+0x4c>
8010847d:	83 ec 0c             	sub    $0xc,%esp
80108480:	68 d8 95 10 80       	push   $0x801095d8
80108485:	e8 16 82 ff ff       	call   801006a0 <cprintf>
8010848a:	83 c4 10             	add    $0x10,%esp
8010848d:	e9 aa fe ff ff       	jmp    8010833c <wmap+0x4c>
80108492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(DEBUG) cprintf("WMAP: fbacked: %d\n", fileBacked);
80108498:	83 ec 08             	sub    $0x8,%esp
8010849b:	50                   	push   %eax
8010849c:	68 10 92 10 80       	push   $0x80109210
801084a1:	e8 fa 81 ff ff       	call   801006a0 <cprintf>
801084a6:	83 c4 10             	add    $0x10,%esp
801084a9:	e9 6b fe ff ff       	jmp    80108319 <wmap+0x29>
801084ae:	66 90                	xchg   %ax,%ax
	if(DEBUG) cprintf("WMAP: Duplicating file descriptor failed;\n");
801084b0:	83 ec 0c             	sub    $0xc,%esp
801084b3:	68 ac 95 10 80       	push   $0x801095ac
801084b8:	e8 e3 81 ff ff       	call   801006a0 <cprintf>
801084bd:	83 c4 10             	add    $0x10,%esp
801084c0:	eb ad                	jmp    8010846f <wmap+0x17f>
801084c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(DEBUG) cprintf("WMAP: Updating wmap at index %d with addr %d, file_backed %d, fd %d\n", emptySpot, addr, fileBacked, fdToStore);
801084c8:	83 ec 0c             	sub    $0xc,%esp
801084cb:	ff 75 d8             	push   -0x28(%ebp)
801084ce:	ff 75 d4             	push   -0x2c(%ebp)
801084d1:	ff 75 08             	push   0x8(%ebp)
801084d4:	ff 75 dc             	push   -0x24(%ebp)
801084d7:	68 24 96 10 80       	push   $0x80109624
801084dc:	e8 bf 81 ff ff       	call   801006a0 <cprintf>
  if(updateWmap(p, addr, length, 0, fileBacked, fdToStore, (p->wmapInfo).total_mmaps+1, emptySpot) != 0) return FAILED;
801084e1:	8b 73 7c             	mov    0x7c(%ebx),%esi
801084e4:	83 c4 20             	add    $0x20,%esp
801084e7:	e9 e3 fe ff ff       	jmp    801083cf <wmap+0xdf>
801084ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801084f0 <wunmap>:

int
wunmap(uint addr)
{
801084f0:	55                   	push   %ebp
801084f1:	89 e5                	mov    %esp,%ebp
801084f3:	53                   	push   %ebx
801084f4:	83 ec 04             	sub    $0x4,%esp
801084f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
/*
This function removes mapping from the process if it exists
*/

  struct proc *p = myproc();
801084fa:	e8 e1 b4 ff ff       	call   801039e0 <myproc>

  // if nothing is mapped then we are done
  if((p->wmapInfo).total_mmaps == 0) return SUCCESS;  
801084ff:	8b 50 7c             	mov    0x7c(%eax),%edx
80108502:	85 d2                	test   %edx,%edx
80108504:	74 50                	je     80108556 <wunmap+0x66>

  for(int i = 0; i < MAX_WMMAP_INFO; i++){
80108506:	31 d2                	xor    %edx,%edx
80108508:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010850f:	90                   	nop
    // continue if not allocated
    if(((p->wmapInfo).addr)[i] == 0 && ((p->wmapInfo).length)[i] == -1){
80108510:	8b 8c 90 80 00 00 00 	mov    0x80(%eax,%edx,4),%ecx
80108517:	85 c9                	test   %ecx,%ecx
80108519:	75 0a                	jne    80108525 <wunmap+0x35>
8010851b:	83 bc 90 c0 00 00 00 	cmpl   $0xffffffff,0xc0(%eax,%edx,4)
80108522:	ff 
80108523:	74 04                	je     80108529 <wunmap+0x39>
	  continue;
    }
 
    // check if given address is free
	if(((p->wmapInfo).addr)[i] == addr){
80108525:	39 d9                	cmp    %ebx,%ecx
80108527:	74 17                	je     80108540 <wunmap+0x50>
  for(int i = 0; i < MAX_WMMAP_INFO; i++){
80108529:	83 c2 01             	add    $0x1,%edx
8010852c:	83 fa 10             	cmp    $0x10,%edx
8010852f:	75 df                	jne    80108510 <wunmap+0x20>
	  return SUCCESS;
	}
  }

  return FAILED;
}
80108531:	8b 5d fc             	mov    -0x4(%ebp),%ebx
		return FAILED;
80108534:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108539:	c9                   	leave  
8010853a:	c3                   	ret    
8010853b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010853f:	90                   	nop
	  if(dellocateAndUnmap(p, addr, ((p->wmapInfo).length)[i], i) != 0){
80108540:	52                   	push   %edx
80108541:	ff b4 90 c0 00 00 00 	push   0xc0(%eax,%edx,4)
80108548:	51                   	push   %ecx
80108549:	50                   	push   %eax
8010854a:	e8 91 f3 ff ff       	call   801078e0 <dellocateAndUnmap>
8010854f:	83 c4 10             	add    $0x10,%esp
80108552:	85 c0                	test   %eax,%eax
80108554:	75 07                	jne    8010855d <wunmap+0x6d>
}
80108556:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  if((p->wmapInfo).total_mmaps == 0) return SUCCESS;  
80108559:	31 c0                	xor    %eax,%eax
}
8010855b:	c9                   	leave  
8010855c:	c3                   	ret    
		if(DEBUG) cprintf("Failed because dellocateAndUnmap failed!\n");
8010855d:	a1 80 37 11 80       	mov    0x80113780,%eax
80108562:	85 c0                	test   %eax,%eax
80108564:	74 cb                	je     80108531 <wunmap+0x41>
80108566:	83 ec 0c             	sub    $0xc,%esp
80108569:	68 6c 96 10 80       	push   $0x8010966c
8010856e:	e8 2d 81 ff ff       	call   801006a0 <cprintf>
80108573:	83 c4 10             	add    $0x10,%esp
80108576:	eb b9                	jmp    80108531 <wunmap+0x41>
80108578:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010857f:	90                   	nop

80108580 <va2pa>:

uint
va2pa(uint va)
{
80108580:	55                   	push   %ebp
80108581:	89 e5                	mov    %esp,%ebp
80108583:	53                   	push   %ebx
80108584:	83 ec 04             	sub    $0x4,%esp
80108587:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pte_t *pte;
  uint pa;

  struct proc *p = myproc();
8010858a:	e8 51 b4 ff ff       	call   801039e0 <myproc>
  if(*pde & PTE_P){
8010858f:	8b 40 04             	mov    0x4(%eax),%eax
  pde = &pgdir[PDX(va)];
80108592:	89 da                	mov    %ebx,%edx
80108594:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80108597:	8b 04 90             	mov    (%eax,%edx,4),%eax
8010859a:	a8 01                	test   $0x1,%al
8010859c:	74 42                	je     801085e0 <va2pa+0x60>
  return &pgtab[PTX(va)];
8010859e:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801085a0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801085a5:	c1 ea 0a             	shr    $0xa,%edx
801085a8:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801085ae:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax

  pte = walkpgdir(p->pgdir, (char*)va, 0);
  if(!pte)  // no pte exist
801085b5:	85 c0                	test   %eax,%eax
801085b7:	74 27                	je     801085e0 <va2pa+0x60>
    return FAILED;
  else if((*pte & PTE_P) != 0){
801085b9:	8b 00                	mov    (%eax),%eax
801085bb:	a8 01                	test   $0x1,%al
801085bd:	74 21                	je     801085e0 <va2pa+0x60>
    pa = PTE_ADDR(*pte);
    if(pa == 0)
801085bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801085c4:	89 c2                	mov    %eax,%edx
801085c6:	74 22                	je     801085ea <va2pa+0x6a>
      panic("kfree");
	return (pa | (va & (PGSIZE-1)));  // concat PFN and Offset
801085c8:	89 d8                	mov    %ebx,%eax
  }
  
  return FAILED;
}
801085ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801085cd:	c9                   	leave  
	return (pa | (va & (PGSIZE-1)));  // concat PFN and Offset
801085ce:	25 ff 0f 00 00       	and    $0xfff,%eax
801085d3:	09 d0                	or     %edx,%eax
}
801085d5:	c3                   	ret    
801085d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801085dd:	8d 76 00             	lea    0x0(%esi),%esi
801085e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return FAILED;
801085e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801085e8:	c9                   	leave  
801085e9:	c3                   	ret    
      panic("kfree");
801085ea:	83 ec 0c             	sub    $0xc,%esp
801085ed:	68 e9 91 10 80       	push   $0x801091e9
801085f2:	e8 89 7d ff ff       	call   80100380 <panic>
801085f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801085fe:	66 90                	xchg   %ax,%ax

80108600 <getwmapinfo>:

int
getwmapinfo(struct wmapinfo *wminfo)
{
80108600:	55                   	push   %ebp
80108601:	89 e5                	mov    %esp,%ebp
80108603:	53                   	push   %ebx
80108604:	83 ec 04             	sub    $0x4,%esp
80108607:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p = myproc();
8010860a:	e8 d1 b3 ff ff       	call   801039e0 <myproc>
8010860f:	89 c2                	mov    %eax,%edx

  (wminfo->total_mmaps) = ((p->wmapInfo).total_mmaps);
80108611:	8b 40 7c             	mov    0x7c(%eax),%eax
80108614:	89 03                	mov    %eax,(%ebx)

  for(int i=0; i<MAX_WMMAP_INFO; i++){
80108616:	31 c0                	xor    %eax,%eax
80108618:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010861f:	90                   	nop
	(wminfo->addr)[i] = ((p->wmapInfo).addr)[i];
80108620:	8b 8c 82 80 00 00 00 	mov    0x80(%edx,%eax,4),%ecx
80108627:	89 4c 83 04          	mov    %ecx,0x4(%ebx,%eax,4)
	(wminfo->length)[i] = ((p->wmapInfo).length)[i];
8010862b:	8b 8c 82 c0 00 00 00 	mov    0xc0(%edx,%eax,4),%ecx
80108632:	89 4c 83 44          	mov    %ecx,0x44(%ebx,%eax,4)
	(wminfo->n_loaded_pages)[i] = ((p->wmapInfo).n_loaded_pages)[i];
80108636:	8b 8c 82 00 01 00 00 	mov    0x100(%edx,%eax,4),%ecx
8010863d:	89 8c 83 84 00 00 00 	mov    %ecx,0x84(%ebx,%eax,4)
  for(int i=0; i<MAX_WMMAP_INFO; i++){
80108644:	83 c0 01             	add    $0x1,%eax
80108647:	83 f8 10             	cmp    $0x10,%eax
8010864a:	75 d4                	jne    80108620 <getwmapinfo+0x20>
  }

  return SUCCESS;
}
8010864c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010864f:	31 c0                	xor    %eax,%eax
80108651:	c9                   	leave  
80108652:	c3                   	ret    

80108653 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80108653:	a1 00 00 00 00       	mov    0x0,%eax
80108658:	0f 0b                	ud2    

8010865a <copyout.cold>:
8010865a:	a1 00 00 00 00       	mov    0x0,%eax
8010865f:	0f 0b                	ud2    
