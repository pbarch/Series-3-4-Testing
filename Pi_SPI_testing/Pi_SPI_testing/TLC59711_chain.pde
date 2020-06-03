class TLC59711_chain {

    // number of registers in the chain
    short chain_len;

    // create an array of TLC59711 objects
    ArrayList<TLC59711> chain_link = new ArrayList<TLC59711>();

    TLC59711_chain(short chain_length){
        chain_len = chain_length;

        // populate arraylist with devices
        for(int i=0; i<chain_len; i++){
            chain_link.add(new TLC59711(i));
        }
    }

}

void write(){
    for (short n = 0; n < chain_len; n++) {
        // send settings MSB first, 1 byte at a time
        spi.transfer(settings >> 24);
        spi.transfer(byte(settings >> 16));
        spi.transfer(byte(settings >> 8));
        spi.transfer(byte(settings));

        // 12 channels per TLC59711
        for (short c = 11; c >= 0; c--) {
            // 16 bits per channel, send MSB first
            spi.transfer(byte(chain_link[n].channel[c] >> 8));
            spi.transfer(byte(chain_link[c]));
        }
    }
}