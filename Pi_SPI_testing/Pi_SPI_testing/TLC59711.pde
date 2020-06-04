class TLC59711 {
    int id;
    int[] channel = new int[12]; // Java doesn't have a 16 bit unsigned data type so store the 16 bit pwm values in 32 bit variables

    TLC59711(int chain_id){
        id = chain_id;
    }
    
    void set_channel(int channel_to_set, int value){
        channel[channel_to_set] = value;
    }
}
