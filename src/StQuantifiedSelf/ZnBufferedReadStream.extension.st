Extension { #name : #ZnBufferedReadStream }

{ #category : #'*StQuantifiedSelf' }
ZnBufferedReadStream >> nextVarint32 [
    | result shift byte |
    result := 0.
    shift := 0.
    
    [ true ] whileTrue: [
        "Read one byte from the stream"
        byte := self next.
        
        "Add the 7 data bits to result"
        result := result bitOr: ((byte bitAnd: 16r7F) bitShift: shift).
        
        "If high bit is not set (MSB = 0), we're done"
        (byte bitAnd: 16r80) = 0 ifTrue: [ ^result ].
        
        "Prepare for next byte"
        shift := shift + 7.
        
        "Guard against malformed data"
        shift > 28 ifTrue: [ self error: 'Malformed varint32' ]
    ]
]
