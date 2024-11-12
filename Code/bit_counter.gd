extends Label

func _process(_delta):
	text = 'bits redeemed : ' + str(CorruptionStats.bits_redeemed) + ' / 100'
