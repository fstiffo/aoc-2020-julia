
const cardpbk = 14012298 # Card's public key
const doorpbk = 74241  # Door's public key
# Puzze input

const subjectnum = 7
# Subject number

const transfnum = 20201227
# Number used in the operaration that transform a subject number



# The card transforms the subject number of 7 according to the card's
# secret loop size. The result is called the card's public key (cardpbk).

function findloopzise(pbk)
    val = 1
    for i in 1:typemax(Int)
        # To transform a subject number (subjectnum), start with the value 1.
        # Then, a number of times called the loop size, perform the following steps:

        val *= subjectnum
        # 1. Set the value to itself multiplied by the subject number.

        val %= transfnum
        # 2. Set the value to the remainder after dividing the value
        # by 20201227 (transfnum)

        if val == pbk
            # The card transforms the subject number of 7 according to
            # the card's secret loop size. The result is called the card's public key.
            # Then when val is equal to out public ket we found our secret loop size

            return i # Secret loop size
        end
    end
end

function findencriptkey(cardpbk, doorpbk)
    cardloopsize = findloopzise(cardpbk)
    doorloopsize = findloopzise(doorpbk)

    # You can use either device's loop size with the other device's public key
    # to calculate the encryption key

    subjectnum = doorpbk
    encriptkey₁ = 1
    for i in 1:cardloopsize
        # The card transforms the subject number of the door's public key
        # according to the card's loop size. The result is the encryption key.

        encriptkey₁ *= subjectnum
        encriptkey₁ %= transfnum
    end

    subjectnum = cardpbk
    encriptkey₂ = 1
    for i in 1:doorloopsize
        # Transforming the subject number of cardpbk (the card's public key)
        # with a loop size of doorloopsize produces the encryption key

        encriptkey₂ *= subjectnum
        encriptkey₂ %= transfnum
    end
    return encriptkey₁, encriptkey₂
end

 findencriptkey(cardpbk, doorpbk)
