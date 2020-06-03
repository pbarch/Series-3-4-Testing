class TLC59711 {
    short id;
    int channel[12]; // Java doesn't have a 16 bit unsigned data type so store the 16 bit pwm values in 32 bit variables

    TLC59711(short chain_id){
        id = chain_id;
    }
}

void set_channel(short channel_to_set, int value){
    channel[channel_to_set] = value;
}