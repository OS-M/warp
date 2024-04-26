package limiter

import "time"

func calculateTick(rps float32) time.Duration {
	return time.Duration(float32(time.Second.Milliseconds())/rps) * time.Millisecond
}

func TickerForRPS(rps float32) *time.Ticker {
	return time.NewTicker(calculateTick(rps))
}
