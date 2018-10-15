function FrameSave(data,FileName)
	frame = squeeze(sum(data));

	frame_bw_contrast = (frame-min(min(frame)))/(max(max(frame))-min(min(frame)));
	imwrite(frame_bw_contrast,FileName);

end